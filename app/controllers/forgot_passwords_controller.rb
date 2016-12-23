class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user
      user.generate_token
      AppMailer.send_password_reset(user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:danger] = params[:email].blank? ? "Email can not be blank" : "Invalid email address"
      redirect_to forgot_password_path
    end
  end
end