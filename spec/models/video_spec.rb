require 'spec_helper'

describe Video do 
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should belong_to(:category) }
  it { should have_many(:reviews).order(created_at: :desc) }

  describe "search_by_title" do

    it "should return an empty array when no match" do
      expect(Video.search_by_title('hello')).to eq([])
    end

    it "should return all Videos when empty string entered" do
      expect(Video.search_by_title('')).to eq(Video.all)
    end

    it "should return all Videos when no argument passed in" do
      video_1 = Video.create(title: "Video 1", description: "A new video")
      video_2 = Video.create(title: "Video 2", description: "Another new video")
      expect(Video.search_by_title).to eq(Video.all)
    end

    it "should return an array including a video with a title that matches the argument" do
      video_1 = Video.create(title: "Video 1", description: "A new video")
      expect(Video.search_by_title("ideo")).to eq([video_1])
    end

    it "should not include videos that don't match the search term" do
      video_1 = Video.create(title: "Video 1", description: "A new video")
      expect(Video.search_by_title("Test")).to eq([])
    end

    it "search should be case insensitive" do
      video_1 = Video.create(title: "Video 1", description: "A new video")
      expect(Video.search_by_title("video 1")).to eq([video_1])
    end

    it "returns an array of one video for an exact match" do
      video_1 = Video.create(title: "Testing", description: "A new video")
      video_2 = Video.create(title: "Another Test", description: "A new video")
      video_3 = Video.create(title: "Test Suite", description: "A new video")
      expect(Video.search_by_title("testing")).to eq([video_1])
    end

    it "should return an array of all matching results ordered by created_at" do
      video_1 = Video.create(title: "Testing", description: "A new video")
      video_2 = Video.create(title: "Another Test", description: "A new video")
      video_3 = Video.create(title: "Test Suite", description: "A new video")
      expect(Video.search_by_title("test")).to eq([video_1, video_2, video_3])
    end
  end
end