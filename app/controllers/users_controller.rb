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
    if @user.valid?
      charge = StripeWrapper::Charge.create(amount: 999, description: "#{@user.full_name} Registration fee", source: params[:stripeToken])
      if charge.successful?
        register_user
      else
        flash.now[:danger] = charge.error_message
        render 'new'
      end
    else
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

  def handle_invitation
    invitation = Invitation.find_by_token(params[:invitation_token])
    @user.follow(invitation.sender)
    invitation.sender.follow(@user)
    invitation.destroy_token
  end

  def register_user
    @user.save
    handle_invitation if params[:invitation_token].present?
    AppMailer.delay.send_welcome_email(@user)
    flash[:success] = "Successfully registered"
    redirect_to login_path
  end
  
end