class Users::RegistrationsController < Devise::RegistrationsController
  def create
    # Handle invitation token if present
    if params[:invitation_token].present?
      @invitation = ClubInvitation.active.find_by(token: params[:invitation_token])
      
      if @invitation.nil?
        flash[:alert] = "Invalid or expired invitation"
        redirect_to new_user_registration_path and return
      end
    end

    super do |resource|
      if resource.persisted?
        # Accept the invitation if user was created successfully
        if @invitation
          @invitation.accept!
          resource.update(club_id: @invitation.club_id)
        end
      end
    end
  end

  private

  def sign_up_params
    # First user becomes super admin
    if User.none?
      params.require(:user).permit(:email, :password, :password_confirmation, :name).merge(role: User::SUPER_ADMIN)
    else
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :role, :club_id)
    end
  end
end