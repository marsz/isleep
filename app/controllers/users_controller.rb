class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @user = current_user
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = User.find current_user.id
    if @user.update_attributes params[:user]
      redirect_to checkins_path
    end
  end
  
end
