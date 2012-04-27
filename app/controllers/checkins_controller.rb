class CheckinsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @checkins = current_user.checkins
    render :index
  end
  
  def create
    @checkin = current_user.checkins.build params[:checkin]
    if @checkin.save
      redirect_to checkins_path
    else
      flash[:error] = @checkin.errors.full_messages.first
      send :index
    end
  end
end
