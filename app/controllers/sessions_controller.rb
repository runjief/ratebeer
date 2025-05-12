class SessionsController < ApplicationController
  def new
      # render the signing up page
  end

  def create
    # retrieves from the database the user that matches the username
    user = User.find_by username: params[:username]
    # saves the user ID who signed up (if the user exists)
    session[:user_id] = user.id if user
    # redirects the user to their own page
    redirect_to user
  end

  def destroy
    # resets the session
    session[:user_id] = nil
    # redirects the application to the main page
    redirect_to :root
  end
end