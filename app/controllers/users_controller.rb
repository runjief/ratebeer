class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :ensure_that_admin, only: [:toggle_frozen]
  # GET /users or /users.json
  def index
    @users = User.includes(:ratings).all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if user_params[:username].nil? and @user == current_user and @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit", status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if current_user == @user
      @user.destroy

      # Clear the session for the destroyed user
      session[:user_id] = nil

      respond_to do |format|
        format.html { redirect_to users_path, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to users_path, notice: "You can only delete your own user account!" }
        format.json { head :forbidden }
      end
    end
  end
  def toggle_frozen
    @user = User.find(params[:id])
    
    unless current_user&.admin?
      redirect_to user_path(@user), notice: "Only admins can freeze/unfreeze accounts"
      return
    end
    
    @user.update_attribute :account_status, (not @user.account_status)

    new_status = @user.account_status? ? "frozen" : "active"

    redirect_to @user, notice: "User account is now #{new_status}"
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
       @user = User.find(params[:id])
    end

  # Only allow a list of trusted parameters through.
  def user_params
    if @user && !@user.new_record?
      params.require(:user).permit(:password, :password_confirmation)
    else
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
  end
end
