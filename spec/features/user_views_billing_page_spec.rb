require 'spec_helper'

feature "User views billing page", { js: true  } do
  background do  
    register_valid_user("alice@example.com", "password", "Alice Doe")
    sign_in_registered_user
    visit billing_path
  end

  scenario "active user views billing page" do
    expect(page).to have_content "Myflix Base Subscription Plan"
  end

  def sign_in_registered_user
    fill_in "Email Address", with: "alice@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"
  end
end