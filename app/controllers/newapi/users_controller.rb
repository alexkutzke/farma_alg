class Newapi::UsersController < ApplicationController
	respond_to :json

	before_filter :authenticate_user!

	def index
		@users = User.all
	end
end