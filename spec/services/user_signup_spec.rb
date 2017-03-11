require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "with valid card and valid personal info" do
      before do
        customer = double('customer', id: "token")
        charge = double('charge', valid?: true, customer: customer)
        allow(StripeWrapper::Customer).to receive(:create).and_return(charge)
      end
      after { ActionMailer::Base.deliveries.clear }

      it "should create the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up(nil, nil)
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up(nil, nil)
        expect(User.first.customer_token).to eq("token")
      end

      it "sends the email to the correct recipient with valid inputs" do
        user = Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "Joe Example")
        UserSignup.new(user).sign_up(nil, nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sends out an email containing the users first name with valid inputs" do
        user = Fabricate.build(:user, email: "joe@example.com", password: "password", full_name: "Joe Example")
        UserSignup.new(user).sign_up(nil, nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Hi Joe,")
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invite = Fabricate(:invitation, sender: alice, recipient_email: "joe@example.com")
        joe = Fabricate.build(:user, email: "joe@example.com")
        UserSignup.new(joe).sign_up(nil, invite.token)
        expect(joe.follows?(alice)).to be true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invite = Fabricate(:invitation, sender: alice, recipient_email: "joe@example.com")
        joe = Fabricate.build(:user, email: "joe@example.com")
        UserSignup.new(joe).sign_up(nil, invite.token)
        expect(alice.follows?(joe)).to be true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invite = Fabricate(:invitation, sender: alice, recipient_email: "joe@example.com")
        UserSignup.new(Fabricate.build(:user)).sign_up(nil, invite.token)
        expect(Invitation.first.token).to be nil
      end
    end

    context "valid personal info and declined card" do
      before do
        charge = double('charge', valid?: false, error_message: "Card declined")
        allow(StripeWrapper::Customer).to receive(:create).and_return(charge)
      end

      it "does not create a new user record" do
        UserSignup.new(Fabricate.build(:user)).sign_up(nil, nil)
        expect(User.count).to eq(0)
      end

      it "doesn't send out an email" do
        UserSignup.new(Fabricate.build(:user)).sign_up(nil, nil)
        expect(ActionMailer::Base.deliveries).to be_empty 
      end

      it "sets the error message" do
        result = UserSignup.new(Fabricate.build(:user)).sign_up(nil, nil)
        expect(result.error_message).to eq("Card declined")
      end
    end

    context "with invalid personal info" do
      it "does not create a user" do
        UserSignup.new(User.new(email: "invalid@user.com")).sign_up(nil, nil)
        expect(User.count).to eq(0)
      end

      it "does not create a subscription" do
        expect(StripeWrapper::Customer).not_to receive(:create)
        UserSignup.new(User.new(email: "invalid@user.com")).sign_up(nil, nil)
      end

      it "doesn't send out an email" do
        UserSignup.new(User.new(email: "invalid@user.com")).sign_up(nil, nil)
        expect(ActionMailer::Base.deliveries).to be_empty 
      end
    end
  end
end