require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:vid) { Fabricate(:video) }
    context "with authenticated user" do
      let(:alice) { Fabricate(:user) }
      before { set_current_user(alice) }

      context "with valid input" do
        before { post :create, review: Fabricate.attributes_for(:review), video_id: vid.id }

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do
          expect(Review.first.video).to eq(vid)
        end

        it "creates a review associated with the signed in user" do
          expect(Review.first.user).to eq(alice)
        end

        it "redirects to the video show page" do
          expect(response).to redirect_to vid
        end
      end

      context "with invalid input" do
        before { post :create, review: { content: "", rating: "" }, video_id: vid.id }

        it "does not create a review" do
          expect(Review.count).to eq(0)
        end

        it "renders the video show template" do
          expect(response).to render_template("videos/show")
        end

        it "sets @video" do
          expect(assigns(:video)).to eq(vid)
        end

        it "sets @reviews" do
          expect(assigns(:reviews)).to match_array(vid.reviews)
        end

      end
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create, review: Fabricate.attributes_for(:review), video_id: vid.id }
    end
  end
end