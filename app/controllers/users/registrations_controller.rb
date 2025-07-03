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
          # Set role to OPERATOR for invited users and assign to club
          resource.update(role: User::OPERATOR, club_id: @invitation.club_id)
        elsif !User.where.not(id: resource.id).exists?
          # First user is already set as SUPER_ADMIN via sign_up_params
        else
          # Default role for non-invited users (shouldn't happen with current flow)
          resource.update(role: User::OPERATOR)
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
      # Don't allow role to be set via params - it should be set based on invitation or defaults
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end
  end
end
