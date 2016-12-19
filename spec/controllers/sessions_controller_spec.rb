require 'spec_helper'

describe SessionsController do
  let(:alice) { Fabricate(:user) }

  describe "GET new" do
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template(:new)
    end
    it "redirects to the home page for authenticated users" do
      session[:user_id] = alice.id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "valid credentials" do
      before { post :create, email: alice.email, password: alice.password }
      it "puts user id in the session hash" do
        expect(session[:user_id]).to eq(alice.id)
      end
      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end
      it "sets the notice" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "invalid credentials" do
      before { post :create, email: alice.email, password: alice.password + "abc" }
      it "renders new template" do
        expect(response).to render_template(:new)
      end
      it "does not create user in session" do
        expect(session[:user_id]).to be_nil
      end
      it "sets notice" do 
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = alice.id
      get :destroy
    end
    
    it "clears the session for the user" do 
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root path" do 
      expect(response).to redirect_to root_path
    end

    it "sets the notice" do 
      expect(flash[:info]).not_to be_blank
    end
  end
end