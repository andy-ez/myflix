require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "require admin" do
      let(:action) { get :new }
    end

    it "sets the video to a new Video" do
      set_current_user(nil, true)
      get :new
      expect(assigns(:video)).to be_a Video
    end


  end

  describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "require admin" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      before do
        set_current_user(nil, true)
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, title: "Example Video", description: "A video for testing" }
      end

      it "creates a video" do
        expect(Video.count).to eq(1)
      end

      it "redirects to the add new video page" do
        expect(response).to redirect_to new_admin_video_path
      end

      it "sets the flsh success message" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid inputs" do
      before do
        set_current_user(nil, true)
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, description: "A video for testing" }
      end

      it "does not create a video" do
        expect(Video.count).to eq(0)
      end

      it "renders new template" do
        expect(response).to render_template :new
      end

      it "sets the @video instance variable" do
        expect(assigns(:video)).to be_a Video
      end

      it "sets a flash error message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end
end