class SessionsController < Devise::SessionsController
	layout "login"
	respond_to :html

	def new
		
	end
end 