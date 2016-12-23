class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Welcome to MyFlix"
  end

  def send_password_reset(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Password Reset"
  end
end