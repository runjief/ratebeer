class ApplicationController < ActionController::Base
  # defines that the method current_user is accessible also from views
  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end
end
