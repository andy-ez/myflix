class PasswordResetsController < ApplicationController
  def show
    user = User.find_by_token(params[:id])
    redirect_to invalid_token_path unless user
  end

  def create
    user = User.find_by_token(params[:id])
    if user
      if params[:password].blank?
        flash[:danger] = "Password can not be empty"
        redirect_to password_reset_url(params[:id])
      else
        user.update_attributes(password: params[:password])
        flash[:success] = "Password successfully reset"
        user.destroy_token
        redirect_to login_path
      end
    else
      redirect_to invalid_token_path
    end
  end

end