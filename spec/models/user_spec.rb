require 'spec_helper'

describe User do 
  it { should validate_presence_of :full_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_uniqueness_of :email }
  it { should have_secure_password }
  it { should have_many(:queue_items).order(position: :asc) }
  it { should have_many(:reviews).order(created_at: :desc) }

  describe "#follows?" do
    it "returns true when there is an existing relationship" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.follows?(bob)).to be true
    end

    it "returns false when there is no existing following relationship" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: alice)
      expect(alice.follows?(bob)).to be false
    end
  end

  describe "#existing_relationship" do
    it "returns the existing relationship if one exists" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.existing_relationship(bob)).to eq(relationship)
    end

    it "returns nil when there is no existing following relationship" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      expect(alice.existing_relationship(bob)).to be_nil
    end
  end

  describe "#generate_token" do
    it "should set the token user attribute" do
      alice = Fabricate(:user)
      alice.generate_token
      expect(alice.token).to be_present
    end
  end
end