class InvitationsController < ApplicationController
  before_action :require_user, only: [:new, :create]
  def new
    @invitation = Invitation.new()
  end

  def create
    @invitation = current_user.sent_invitations.build(invitaion_params)
    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash[:success] = "Invitation Sent"
      redirect_to new_invitation_path
    else
      flash.now[:danger] = "Error see below"
      render 'new'
    end
  end

  private 

  def invitaion_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end