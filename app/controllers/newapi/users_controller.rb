class Newapi::UsersController < ApplicationController
	respond_to :json

	before_filter :authenticate_user!
  before_filter :verify_admin

	def index
		@users = User.all
	end
end
