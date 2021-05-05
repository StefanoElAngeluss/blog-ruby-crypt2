class UsersController < ApplicationController

  before_action :require_admin, only: [:ban, :destroy, :resend_confirmation_instructions]
  before_action :require_admin_or_inviter, only: [:resend_invitation]
  before_action :require_admin_or_owner, only: [:edit, :update]

  def index
    @users = User.all.order(created_at: :asc)
    unless current_user.admin?
      redirect_to (request.referrer || root_path), alert: "vous n'êtes pas autorisé à effectuer cette action!"
    end
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
    if @user == current_user
      redirect_to @user, alert: "Vous ne pouvez pas vous bannir vous-même"
    else
      if @user.access_locked?
        @user.unlock_access!
        redirect_to users_path, notice: "Accès utilisateur verrouillé: #{"Non"}"
      else
        @user.lock_access!
        redirect_to users_path, notice: "Accès utilisateur verrouillé: #{"Oui"}"
      end
    end
  end

  private

  def user_params
    list_allowed_params = []
    list_allowed_params += [:name] if current_user == @user || current_user.admin?
    list_allowed_params += [*User::ROLES] if current_user.admin?
    params.require(:user).permit(list_allowed_params)
    # params.require(:user).permit(*User::ROLES, :username)
  end

  def require_admin
    unless current_user.admin?
      redirect_to (request.referrer || root_path), alert: "vous n'êtes pas autorisé à effectuer cette action!"
    end
  end

  def require_admin_or_inviter
    @user = User.find(params[:id])
    unless current_user.admin? || @user.invited_by == current_user
      redirect_to (request.referrer || root_path), alert: "vous n'êtes pas autorisé à effectuer cette action!"
    end
  end

  def require_admin_or_owner
    @user = User.find(params[:id])
    unless current_user.admin? || current_user == @user
      redirect_to (request.referrer || root_path), alert: "vous n'êtes pas autorisé à effectuer cette action!"
    end
  end

end