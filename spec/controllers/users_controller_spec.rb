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
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "should create the user" do
        expect(User.count).to eq(1)
      end
      it "should redirect to the sign in page" do
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid inputs" do
      before do
        post :create, user: {email: "testing@test.com"}
      end
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
  end

end