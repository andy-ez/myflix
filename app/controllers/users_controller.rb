class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  def new
    @user = User.new
  end

  def new_with_invitation_token
    invitation = Invitation.find_by_token(params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new(user_params)
    sign_up = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])
    if sign_up.successful?
      flash[:success] = "Successfully registered"
      redirect_to login_path
    else
      flash.now[:danger] = sign_up.error_message
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :full_name, :password)
  end
  
end