require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "successful user signup" do
      before do
        result = double('result', successful?: true )
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "should set the flash success" do
        expect(flash[:success]).not_to be_empty
      end

      it "should redirect to the sign in page" do
        expect(response).to redirect_to login_path
      end
    end

    context "failed user signup" do
      before do
        result = double('result', successful?: false, error_message: "This is an error message" )
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end
      
      it "should set the flash error" do
        expect(flash[:danger]).to eq("This is an error message")
      end

      it "sets the @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "should render the new template" do
        expect(response).to render_template :new
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