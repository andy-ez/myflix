require 'spec_helper'


describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid inputs" do
      it "should create the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "should redirect to the sign in page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to login_path
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invite = Fabricate(:invitation, sender: alice, recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Doe" }, invitation_token: invite.token
        joe = User.find_by_email("joe@example.com")
        expect(joe.follows?(alice)).to be true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invite = Fabricate(:invitation, sender: alice, recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Doe" }, invitation_token: invite.token
        joe = User.find_by_email("joe@example.com")
        expect(alice.follows?(joe)).to be true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invite = Fabricate(:invitation, sender: alice, recipient_email: "joe@example.com")
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Doe" }, invitation_token: invite.token
        joe = User.find_by_email("joe@example.com")
        expect(Invitation.first.token).to be nil
      end
    end

    context "with invalid inputs" do
      before { post :create, user: {email: "testing@test.com"} }

      it "does not create a user" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do 
        expect(response).to render_template(:new)
      end
      
      it "sets the @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "email sending" do
      after { ActionMailer::Base.deliveries.clear }
      it "sends the email to the correct recipient with valid inputs" do
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Example" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sends out an email containing the users first name with valid inputs" do
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Example" }
        expect(ActionMailer::Base.deliveries.last.body).to include("Hi Joe,")
      end

      it "doesn't send out an email with invalid inputs" do
        post :create, user: { email: "joe@example.com" }     
        expect(ActionMailer::Base.deliveries).to be_empty 
      end
    end
  end

  describe "GET show" do
    let(:alice) { Fabricate(:user) }
    context "with authenticated user" do
      before { set_current_user(alice) }

      it "sets @user" do
        get :show, id: alice.id
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "sets @user to the user that matches the id" do
        get :show, id: alice.id
        expect(assigns(:user)).to eq(alice)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { get :show, id: Fabricate(:user).id }
    end
  end

  describe "GET new_with_invitation_token" do
    let(:invitation) { Fabricate(:invitation) }
    it "renders the new view template" do
      get :new_with_invitation_token, token: invitation.token 
      expect(response).to render_template :new
    end

    it "sets @user to recipient" do
      get :new_with_invitation_token, token: invitation.token 
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token instance_var" do
      get :new_with_invitation_token, token: invitation.token 
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to invalid token page for invalid tokens" do
      get :new_with_invitation_token, token: "wrong_token" 
      expect(response).to redirect_to invalid_token_path
    end
  end
end