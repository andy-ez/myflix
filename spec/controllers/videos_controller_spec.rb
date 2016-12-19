require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:new_vid) { Fabricate(:video) }

    context "authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
        get :show, id: new_vid.id
      end

      it "should assign variable @video if user is authenticated" do
        expect(assigns(:video)).to eq(new_vid)
      end

      it "sets @reviews for authenticated users" do
        review1 = Fabricate(:review, video: new_vid)
        review2 = Fabricate(:review, video: new_vid)
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end

    context "unauthenticated user" do
      it "should redirect to root" do
        get :show, id: new_vid.id
        expect(response).to redirect_to root_path
      end
    end

  end

  describe "GET search" do
    it "should assign variable videos if user is authenticated" do
      session[:user_id] = Fabricate(:user).id
      5.times { Fabricate(:video) }
      get :search, title: Video.first.title
      expect(assigns(:videos)).to eq([Video.first])
    end

    it "redirects to root if unathenticated" do 
      5.times { Fabricate(:video) }
      get :search, title: Video.first.title
      expect(response).to redirect_to root_path
    end
  end
end