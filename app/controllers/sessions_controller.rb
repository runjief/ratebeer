class SessionsController < ApplicationController
  def new
      # render the signing up page
  end

  def create
    user = User.find_by username: params[:username]
    if user.nil?
        redirect_to signin_path, notice: "User #{params[:username]} does not exist!"
    else
        session[:user_id] = user.id
        redirect_to user, notice: "Welcome back!"
    end
  end

  def destroy
    # resets the session
    session[:user_id] = nil
    # redirects the application to the main page
    redirect_to :root
  end
end