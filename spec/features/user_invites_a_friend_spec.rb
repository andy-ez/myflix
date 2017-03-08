require 'spec_helper'

feature "User Invites a friend" do
  scenario "User successfully invites a friend and the invitation is accepted" do
    alice = Fabricate(:user)
    friend = Fabricate.attributes_for(:user)
    sign_in(alice)
    invite_a_friend

    friend_accepts_invitation
    friend_signs_in
    friend_should_follow(alice)
    inviter_should_follow_friend(alice)

  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "John Doe"
    fill_in "Friend's Email Address", with: "john@example.com"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email("john@example.com")
    current_email.click_link "Accept This Invitation"
    fill_in "Password", with: "password"
    fill_in "Full name", with: "John Doe"
    click_button "Register"
  end

  def friend_signs_in
    fill_in "Email Address", with: "john@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end

  def inviter_should_follow_friend(user)
    sign_in(user)
    click_link "People"
    expect(page).to have_content "John Doe"
  end
end