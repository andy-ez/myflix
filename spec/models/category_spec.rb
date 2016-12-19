require 'spec_helper'

describe Category do 
  it { should validate_presence_of(:title) }
  it { should have_many(:videos).class_name('Video') }

  describe "#recent_videos" do
    it "should return an empty array if there are no videos in the category" do
      action = Category.create(title: "Action")
      expect(action.recent_videos).to eq([])
    end

    it "should return all videos in a category if less than 6, in reverse chronical order by created_at" do
      action = Category.create(title: "Action")
      video_1 = Video.create(title: 'Video 1', description: 'first movie', category: action)
      video_2 = Video.create(title: 'Video 2', description: 'second movie', category: action, created_at: 1.day.ago)
      video_3 = Video.create(title: 'Video 3', description: 'third movie', category: action)
      expect(action.recent_videos).to eq([video_3, video_1, video_2])
    end

    it "returns 6 videos if category has greater than 6" do 
      action = Category.create(title: "Action")
      7.times { Video.create(title: "Test", description: "testing", category: action) }
      expect(action.recent_videos.size).to eq(6)
    end
  end
end