class SessionsController < ApplicationController
  def new
    # render the signing up page
  end

  def create
    user = User.find_by username: params[:username]
    
    if user&.account_status?
      redirect_to signin_path, notice: "Your account is frozen, please contact admin"
      return
    end
    
    if user&.authenticate(params[:password])
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
