require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank email" do
      before do
        ActionMailer::Base.deliveries.clear
        post :create, email: ""
      end
      it "redirects to forgot password path" do
        expect(response).to redirect_to forgot_password_path
      end
      it "sets flash error message" do
        expect(flash[:danger]).to eq("Email can not be blank")
      end
      it "does not send an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "with valid email" do
      let(:alice) { Fabricate(:user) }
      before { post :create, email: alice.email }
      it "should redirect to confirm password reset page" do
        expect(response).to redirect_to(confirm_password_reset_path)
      end
      it "should send an email to the correct user" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([alice.email])
      end
      it "should generate a token for the user" do
        expect(alice.reload.token).not_to be nil
      end
      it "should send an email containing a link with the token" do
        expect(ActionMailer::Base.deliveries.last.body).to include("/password_resets/#{alice.token}")
      end
    end

    context "with invalid email" do
      before do
        ActionMailer::Base.deliveries.clear
        post :create, email: "joe@example.com"
      end
      it "redirects to forgot_password_path" do
        expect(response).to redirect_to forgot_password_path
      end
      it "sets flash error message" do
        expect(flash[:danger]).to eq("Invalid email address")
      end
      it "does not send an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

end