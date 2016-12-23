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
      before { post :create, user: Fabricate.attributes_for(:user) }

      it "should create the user" do
        expect(User.count).to eq(1)
      end

      it "should redirect to the sign in page" do
        expect(response).to redirect_to login_path
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
end