require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to match_array([relationship])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    before { set_current_user(alice) }

    it "redirects to people path" do
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end

    it "creates a new relationship" do
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end

    it "creates a new relationship where current user is the follower" do
      post :create, leader_id: bob.id
      expect(Relationship.first.follower).to eq(current_user)
    end

    it "creates a new relationship where current user follows user with given user id" do
      post :create, leader_id: bob.id
      expect(Relationship.first.leader).to eq(bob)
    end

    it "doesn't create a relationship if one already exists" do
      Fabricate(:relationship, leader: bob, follower: alice)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end

    it "doesn't allow a user to follow themself" do
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq(0)
    end

    it "sets flash error if relationship already exists" do
      Fabricate(:relationship, leader: bob, follower: alice)
      post :create, leader_id: bob.id
      expect(flash[:danger]).to be_present
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create, leader_id: 1 }
    end
  end

  describe "DELETE destroy" do
    context "with authenmticated user" do
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }

      before { set_current_user(alice) }

      it "deletes the relationship if the current user is the follower" do
        relationship = Fabricate(:relationship, leader: bob, follower: alice)
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(0)
      end

      it "redirects to the people page" do
        relationship1 = Fabricate(:relationship, leader: bob, follower: alice)
        delete :destroy, id: relationship1.id
        expect(response).to redirect_to people_path
      end

      it "does not delete the relationship if the current_user is not the follower" do
        relationship = Fabricate(:relationship, leader: alice, follower: bob)
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(1)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { delete :destroy, id: Fabricate(:relationship).id }
    end
  end
end