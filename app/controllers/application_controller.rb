class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	before_action :configure_devise_parameters, if: :devise_controller?
	helper_method :is_admin!

	def configure_devise_parameters
		devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
	end

	def after_sign_in_path_for(resource)
		user_path(resource)
	end

	def to_boolean(str)
	  return true if str=="Oui"
	end

	private

	def is_admin!
		if current_user && current_user.admin
		else
			redirect_to root_path
		end
	end

end
