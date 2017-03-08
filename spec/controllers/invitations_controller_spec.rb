require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitaion instance variable" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a Invitation
    end

    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end

    context "with valid inputs" do
      let(:alice) { Fabricate(:user) }
      before do
        set_current_user(alice)
        post :create, invitation: { recipient_name: "Alice Example", recipient_email: "alice@example.com", message: "Come and join this cool website" }
      end
      it "creates an invitation" do
        expect(Invitation.first.sender).to eq(alice)
        expect(Invitation.first.recipient_name).to eq("Alice Example")
      end

      it "sends an email to the recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["alice@example.com"])
      end

      it "redirects to the new invitation page" do
        expect(response).to redirect_to new_invitation_path
      end

      it "sets the flash success message" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid inputs" do
      let(:alice) { Fabricate(:user) }
      before do
        set_current_user(alice)
        post :create, invitation: { recipient_email: "alice@example.com", message: "Come and join this cool website" }
      end

      it "does not cerate an invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "should set the flash error message" do
        expect(flash[:danger]).not_to be_blank
      end

      it "sets the @invitation instance variable" do
        expect(assigns(:invitation)).to be_a Invitation
      end
    end
  end
end