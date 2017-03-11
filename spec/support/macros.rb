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

def sign_in_admin
  sign_in(Fabricate(:user, admin: true))
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