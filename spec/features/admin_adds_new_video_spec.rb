require 'spec_helper'

feature "admin adds new video" do
  scenario "admin successfully adds new video" do
    admin = Fabricate(:user, admin: true)
    drama = Fabricate(:category, title: "Dramas")
    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "New Video"
    select "Dramas", from: "Category"
    fill_in "Description", with: "A new video for testing"

    attach_file "Large Cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small Cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.example.com/my_video.mp4"
    click_button "Create Video"


    sign_out
    sign_in
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/video/large_cover/VideoNew/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']")
  end
end