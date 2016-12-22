require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:new_vid) { Fabricate(:video) }

    context "authenticated user" do
      before do
        set_current_user
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

    it_behaves_like "require sign in" do
      let(:action) { get :show, id: new_vid.id }
    end

  end

  describe "GET search" do
    before { 5.times { Fabricate(:video) } }
    it "should assign variable videos if user is authenticated" do
      set_current_user
      get :search, title: Video.first.title
      expect(assigns(:videos)).to eq([Video.first])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :search, title: Video.first.title }
    end
  end
end