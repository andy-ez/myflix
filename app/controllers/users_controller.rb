class UsersController < ApplicationController
  before_action :require_user, only: [:show, :edit, :update, :plan_and_billing]
  def new
    redirect_to home_path if logged_in?
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

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:success] = "Updated Account Information"
      redirect_to home_path
    else
      flash.now[:danger] = "See errors below"
      render :edit
    end
  end

  def plan_and_billing
    customer = StripeWrapper::Customer.retrieve(current_user)
    @customer = StripeCustomerDecorator.new(customer)
    @invoices = StripeWrapper::Invoice.list(current_user).map { |invoice| StripeInvoiceDecorator.new(invoice) }
    cancel_subscription if params[:cancel].present?
  end

  private

  def user_params
    params.require(:user).permit(:email, :full_name, :password, :password_confirmation)
  end

  def cancel_subscription
    subscription = StripeWrapper::Subscription.cancel_subscription(current_user)
    current_user.active = false
    current_user.save
    flash[:info] = "Your account is no longer active"
    redirect_to logout_path
  end
  
end