shared_examples "require sign in" do
  it "redirects to the root path" do
    clear_current_user
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples "require admin" do
  it "redirects the regular user to their home path" do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end

  it "sets the flash error message for a regular user" do
    set_current_user
    action
    expect(flash[:danger]).not_to be_blank
  end
end