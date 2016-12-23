require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    commedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: commedies)
    south_park = Fabricate(:video, title: "South Park", category: commedies)
    futurama = Fabricate(:video, title: "Futurama", category: commedies)

    sign_in

    add_video_to_queue(monk)
    expect(page).to have_content(monk.title)

    click_link monk.title
    expect(page).not_to have_content("+ My Queue")

    add_video_to_queue(south_park)
    add_video_to_queue(futurama)

    set_video_position(monk, '3')

    click_button "Update Instant Queue"
    expect_video_position(monk, '3')
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position)
  end
end