require 'spec_helper'

describe QueueItem do 
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_numericality_of(:position).only_integer }
  let(:monk) { Fabricate(:video, title: "Monk") }

  describe "#video_title" do
    it "should return the title of the associated video" do
      queue = Fabricate(:queue_item, video: monk)
      expect(queue.video_title).to eq("Monk")
    end
  end

  describe "#rating" do
    it "should return the rating given by current user of the video if user has reviewed" do
      alice = Fabricate(:user)
      Fabricate(:review, user: alice, video: monk, rating: 3)
      queue = Fabricate(:queue_item, video: monk, user: alice)
      expect(queue.rating).to eq(3)
    end

    it "should return nil if user hasn't reviewed the video" do
      alice = Fabricate(:user)
      queue = Fabricate(:queue_item, video: monk, user: alice)
      expect(queue.rating).to be_nil
    end
  end

  describe "#category_title" do
    it "should return the category title for the video associated with the queue item" do
      queue = Fabricate(:queue_item, video: monk)
      expect(queue.category_title).to eq(monk.category.title)
    end
  end

  describe "#category" do
    it "should return the category for the video associated with the queue item" do
      queue = Fabricate(:queue_item, video: monk)
      expect(queue.category).to eq(monk.category)
    end
  end

  describe "#rating=" do
    let(:alice) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: alice) }

    it "changes the rating of the review if the review is present" do
      review = Fabricate(:review, video: video, user: alice, rating: 1)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end
    it "can clear the rating of the review if a review is present" do
      review = Fabricate(:review, video: video, user: alice, rating: 1)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end
    it "creates a review with the rating if none is present" do
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end
  end

end