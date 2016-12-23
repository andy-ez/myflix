require 'spec_helper'

feature "User Following" do
  scenario "User follows and unfollows someone" do
    alice = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    review = Fabricate(:review, user: alice, video: video)
    sign_in

    click_video_on_home_page(video)
    click_link alice.full_name
    click_link "Follow"
    expect(page).to have_content(alice.full_name)
    find("a[data-method='delete']").click
    visit people_path

    expect(page).not_to have_content(alice.full_name)

  end
end