class SessionsController < ApplicationController
  def new
    # render the signing up page
  end

  def create
    user = User.find_by username: params[:username]
    # check that user exists and the password is correct
    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
    else
        redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil
    
    redirect_to root_path, notice: "Signed out!"
  end
end
