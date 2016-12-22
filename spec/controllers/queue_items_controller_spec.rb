require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    
    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:video) { Fabricate(:video) }
    let(:alice) { Fabricate(:user) }

    context "with authenticated user" do
      before do
        set_current_user(alice)
        post :create, video_id: video.id
      end

      it "should redirect to my queue" do
        expect(response).to redirect_to my_queue_path
      end
      
      it "creates a queue item" do
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue item associated with the current user" do
        expect(QueueItem.first.user).to eq(alice)
      end

      it "creates a queue item associated with the video" do
        expect(QueueItem.first.video).to eq(video)
      end

      it "should add the video to the end of my queue if not already queued" do
        new_vid = Fabricate(:video)
        post :create, video_id: new_vid.id
        expect(QueueItem.find_by(video_id: new_vid.id).position).to eq(2)
      end

      it "should not add the video to my queue if already queued" do 
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create, video_id: Fabricate(:video).id }
    end

  end

  describe "POST update" do

    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:video1) { Fabricate(:video) }
    let(:queue_item1) { Fabricate(:queue_item, position: 1, user: alice, video: video) }
    let(:queue_item2) { Fabricate(:queue_item, position: 2, user: alice, video: video1) }
    let(:queue_item3) { Fabricate(:queue_item, position: 1, user: bob, video: video) }

    context "with valid inputs" do
      before do
        set_current_user(alice)
      end

      it "redirects to my queue page" do
        post :update, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 1 } ]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items by changing position" do
        post :update, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 1 } ]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "normalizes the posiiton" do
        post :update, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 5 } ]
        expect(queue_item1.reload.position).to eq(1)
        expect(QueueItem.find(queue_item2.id).position).to eq(2)
      end
    end

    context "with invalid inputs" do
      before do
        set_current_user(alice)
        post :update, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 2.5 } ]
      end

      it "redirects to the my queue page" do
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue" do
        expect(queue_item1.reload.position).to eq(1)
        expect(queue_item2.reload.position).to eq(2)
      end
    end

    context "with wrong user" do
      before do
        set_current_user(alice)
        post :update, queue_items: [{ id: queue_item3.id, position: 2 } ]
      end

      it "should redirect to my queue page" do
        expect(response).to redirect_to my_queue_path
      end

      it "should not change queue" do
        expect(queue_item3.reload.position).to eq(1)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { post :update, queue_items: [{ id: queue_item3.id, position: 2 } ] }
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:item) { Fabricate(:queue_item, user: alice, video: Fabricate(:video), position: 1) }
    let(:item2) { Fabricate(:queue_item, position: 2, user: alice) }
    let(:item3) { Fabricate(:queue_item, position: 3, user: alice) }
    
    context "with authenticated user" do
      before { set_current_user(alice) }

      it "should redirect to the my queue page" do
        delete :destroy, id: item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item" do
        delete :destroy, id: item.id
        expect(QueueItem.count).to eq(0)
      end

      it "doesnt delete the queue item if current user doesn't own it" do
        new_item = Fabricate(:queue_item, user: Fabricate(:user), video: Fabricate(:video))
        delete :destroy, id: new_item.id
        expect(QueueItem.count).to eq(1)
      end

      it "normalizes position after deleteing" do
        item1 = Fabricate(:queue_item, position: 1, user: alice)
        item2 = Fabricate(:queue_item, position: 2, user: alice)
        item3 = Fabricate(:queue_item, position: 3, user: alice)
        delete :destroy, id: item2.id
        expect(item3.reload.position).to eq(2)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { delete :destroy, id: item2.id }
    end
  end
end