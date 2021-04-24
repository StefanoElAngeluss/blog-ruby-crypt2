class UsersController < ApplicationController

	before_action :only_admin, only: [:edit, :update, :ban, :destroy]

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

  def only_admin
    unless current_user.admin?
      redirect_to root_path, notice: "vous n'êtes pas autorisé à effectuer cette action!"
    end
  end

end