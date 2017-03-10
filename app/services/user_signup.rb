class UserSignup
  attr_accessor :status, :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(amount: 999, description: "#{@user.full_name} Registration fee", source: stripe_token)
      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.delay.send_welcome_email(@user)
        @status = :success
      else
        @status = :failed
        @error_message = charge.error_message
      end
    else
      @status = :failed
      @error_message = "Invalid user information"
    end
    self
  end

  def successful?
    status == :success
  end

  private 
  
  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by_token(invitation_token)
      @user.follow(invitation.sender)
      invitation.sender.follow(@user)
      invitation.destroy_token
    end
  end
end