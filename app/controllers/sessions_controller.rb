class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  def new
    redirect_to home_path if logged_in?
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "Successfully signed in as #{@user.full_name}"
      redirect_to home_path
    else
      flash[:danger] = "Invalid login details."
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "Successfully signed out."
    redirect_to root_path
  end
end