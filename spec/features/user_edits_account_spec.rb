require 'spec_helper'

feature "User edits account info" do
  let(:alice) { Fabricate(:user, full_name: "Alice Doe", email: "alice@example.com", password: "password") }

  background do
    sign_in(alice)
    visit account_path
  end

  scenario "Edits full name" do
    fill_in "Full Name", with: "Alice Example"
    click_button "Update"
    expect(page).to have_content("Welcome, Alice Example")
    expect(page).to have_content("Updated Account Information")
  end

  scenario "Edits email address" do
    fill_in "Email Address", with: "alice@doe.com"
    click_button "Update"
    expect(page).to have_content("Updated Account Information")
    sign_out
    sign_in_with_details("alice@doe.com", "password")
    expect(page).to have_content("Welcome, Alice Doe")
  end

  scenario "Unsuccessfully Edits Password" do
    fill_in "Password", with: "new_password"
    click_button "Update"
    expect(page).to have_content("Your Account")
    expect(page).to have_content("See errors below")
  end

  scenario "successfully Edits Password" do
    fill_in "Password", with: "new_password"
    fill_in "Confirm Password", with: "new_password"
    click_button "Update"
    expect(page).to have_content("Updated Account Information")
    sign_out
    sign_in_with_details("alice@example.com", "new_password")
    expect(page).to have_content("Welcome, Alice Doe")
  end
end