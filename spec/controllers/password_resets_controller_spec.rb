require 'spec_helper'

describe PasswordResetsController do

  describe "GET show" do
    let(:alice) { Fabricate(:user) }
    before { alice.generate_token }
    
    it "should render show template if token is valid" do
      get :show, id: alice.token
      expect(response).to render_template(:show)
    end

    it "should redirect to invalid token page if token is invalid" do
      get :show, id: "invalid_token"
      expect(response).to redirect_to invalid_token_path   
    end
  end
  describe "POST create" do
    let(:alice) { Fabricate(:user, password: "old_password") }
    context "with valid token" do
      before do
        alice.generate_token
        post :create, id: alice.token, password: "new_password"
      end
      
      it "should redirect to login path" do
        expect(response).to redirect_to login_path
      end

      it "should change the password to the newly entered password" do
        expect(alice.reload.authenticate("new_password")).to be_truthy
      end

      it "should set flash success message" do
        expect(flash[:success]).to eq("Password successfully reset")
      end

      it "should delete the user's token" do
        expect(alice.reload.token).to be_nil
      end

    end

    context "with empty new password" do
      before do
        alice.generate_token
        post :create, id: alice.token, password: ""
      end

      it "should not reset password" do
        expect(alice.reload.authenticate("old_password")).to be_truthy
      end
      
      it "should redirect to show path" do
        expect(response).to redirect_to(password_reset_path(alice.token))
      end

      it "should set flash error message" do
        expect(flash[:danger]).to eq("Password can not be empty")
      end
    end

    context "with invalid token" do
      before { post :create, id: "12345" }

      it "should redirect to invalid token page" do
        expect(response).to redirect_to invalid_token_path
      end
    end

    context "with no token" do
      before { post :create }

      it "should redirect to invalid token page" do
        expect(response).to redirect_to invalid_token_path
      end
    end
  end

end