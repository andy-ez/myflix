def set_current_user(user=nil, admin=false)
  session[:user_id] = (user || Fabricate(:user, admin: admin)).id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(user=nil)
  a_user = user || Fabricate(:user)
  visit login_path
  fill_in "Email Address", with: a_user.email
  fill_in "Password", with: a_user.password
  click_button "Sign In"
end

def sign_in_with_details(email, password)
  visit login_path
  fill_in "Email Address", with: email
  fill_in "Password", with: password
  click_button "Sign In"
end

def sign_in_admin
  sign_in(Fabricate(:user, admin: true))
end

def register_valid_user(email="alice@example.com", password="password", name="Alice Doe")
  visit register_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  fill_in "Full name", with: name
  within_frame(find('iframe')) do
    fill_in_slowly("input[name='cardnumber']", "4242424242424242")
    fill_in name: 'exp-date', with: '11/20'
    fill_in name: 'cvc', with: '123'
    fill_in name: 'postal', with: '90210'
  end
  click_button "Register"
end

def sign_out
  visit logout_path
end

def fill_in_slowly(location, with)
  input_field = find(location)
  with.each_char { |char| input_field.send_keys(char) }
end

def click_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end