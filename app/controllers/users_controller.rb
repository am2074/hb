class UsersController < ApplicationController
before_action :authenticate_user!
before_action :set_user

	def show 
	end

	def user_reviews
	end


private 
	def set_user
		@users= User.find(params[:id])
	end 
end
