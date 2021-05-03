class UsersController < ApplicationController

	before_action :require_admin, only: [:edit, :update, :ban, :destroy, :resend_confirmation_instructions]
	before_action :require_admin_or_inviter, only: [:resend_invitation]

	def index
		@users = User.all.order(created_at: :asc)
	end

	def show
		@user = User.find(params[:id])
	end

	def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.update(user_params)
      redirect_to @user, notice: "L'utilisateur a été mis à jour avec succès."
    else
      render :edit
    end
  end

	def destroy
		@user = User.find(params[:id])
		@user.destroy
		redirect_to users_path, notice: "Votre compte à été supprimer avec succès."
	end

	def resend_confirmation_instructions
		@user = User.find(params[:id])
		if @user.confirmed? == false && @user.created_by_invite? == false
			@user.resend_confirmation_instructions
			redirect_to @user, notice: "Les instructions de confirmation ont bien été renvoyées"
		else
			redirect_to @user, alert: "L'utilisateur à déjà confirmé"
		end
	end

	def resend_invitation
		@user = User.find(params[:id])
		if @user.created_by_invite? && @user.invitation_accepted? == false && @user.confirmed? == false
			@user.invite!
			redirect_to @user, notice: "Les instructions d'invitation ont bien été renvoyées"
		else
			redirect_to @user, alert: "L'utilisateur à déjà confirmé"
		end
	end

	def ban
		@user = User.find(params[:id])
		if @user.access_locked?
			@user.unlock_access!
		else
			@user.lock_access!
		end
		if @user.access_locked?
			# redirect_to @user, notice: "Accès utilisateur verrouillé: #{@user.access_locked?}"
			redirect_to users_path, notice: "Accès utilisateur verrouillé: #{"Oui"}"
		else
			redirect_to users_path, notice: "Accès utilisateur verrouillé: #{"Non"}"
		end
	end

	private

  def user_params
    params.require(:user).permit(*User::ROLES)
  end

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "vous n'êtes pas autorisé à effectuer cette action!"
    end
  end

  def require_admin_or_inviter
  	@user = User.find(params[:id])
  	unless current_user.admin? || @user.invited_by == current_user
      redirect_to root_path, alert: "vous n'êtes pas autorisé à effectuer cette action!"
    end
  end

end