require 'spec_helper'

feature 'Admin sees payments' do
  background do
    alice = Fabricate(:user, full_name: "Alice Doe", email: "alice@example.com")
    Fabricate(:payment, user: alice, amount: 999)
  end

  scenario "Admin can view payments" do
    sign_in_admin
    visit admin_payments_path
    expect(page).to have_content "$9.99"
    expect(page).to have_content "Alice Doe"
    expect(page).to have_content "alice@example.com"
  end

  scenario "User can not see payments" do
    sign_in
    visit admin_payments_path
    expect(page).not_to have_content "$9.99"
    expect(page).to have_content "You don't have permission to do that"
  end
end