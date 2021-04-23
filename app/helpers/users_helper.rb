module UsersHelper

	def ban_status(user)
		if user.access_locked?
			"Ne pas bannir"
		else
			"Bannir"
		end
	end

end