class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy, :confirm]
  before_action :ensure_current_user, only: [ :new, :create ]
  before_action :ensure_that_signed_in, except: [:index, :show]
  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = current_user ? BeerClub.all - current_user.beer_clubs : BeerClub.all
  end

  # GET /memberships/1/edit
  def edit
    @beer_clubs = current_user ? BeerClub.all - current_user.beer_clubs : BeerClub.all
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user
    @membership.confirmed = false
    respond_to do |format|
      if @membership.save
        format.html { redirect_to beer_club_url(@membership.beer_club_id), notice: "Your application for membership is pending confirmation." }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    membership = Membership.find_by(
      beer_club_id: params[:beer_club_id],
      user_id: current_user.id
    )
    
    beer_club = membership.beer_club
    
    membership.destroy if membership

    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Membership in #{beer_club.name} ended." }
      format.json { head :no_content }
    end
  end
  def confirm
    if @membership.beer_club.confirmed_members.include?(current_user)
      @membership.confirm!
      redirect_to @membership.beer_club, notice: "Membership confirmed!"
    else
      redirect_to @membership.beer_club, notice: "Only members can confirm applications"
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
    def ensure_current_user
      redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
    end

      def set_membership
        @membership = Membership.find(params[:id])
      end

      def set_beer_clubs
        @beer_clubs = BeerClub.all
      end
end
