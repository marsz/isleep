class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def after_sign_in_path_for(user)
    request.env['omniauth.origin'] || checkins_path
  end

  def after_sign_out_path_for(user)
    checkins_path
  end
  
end
