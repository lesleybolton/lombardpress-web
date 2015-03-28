class Users::ProfilesController < ApplicationController
	before_filter :authenticate_user!
  

	def index
		#unless current_user.admin?
		 #	redirect_to "/permissions", :alert => "Access denied."
    #end
    @users = User.all
    authorize @users
	end
	def show
		@user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to "/permissions", :alert => "Access denied."
      end
    end
	end

end