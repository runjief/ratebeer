class BreweriesController < ApplicationController
  before_action :expire_breweries_cache, only: [:create, :update, :destroy, :toggle_activity]
  before_action :set_brewery, only: %i[ show edit update destroy toggle_activity ]
  before_action :ensure_that_signed_in, except: [ :index, :show, :list ]
  before_action :ensure_that_admin, only: [:destroy]
  
  # GET /breweries or /breweries.json
  def index
    @order = params[:order] || 'name'
    
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired
    
    return if request.format.html? && fragment_exist?("brewerylist-active-#{@order}")
    
    all_breweries = Brewery.includes(:beers, :ratings).all
    
    sorted_breweries = case @order
                      when "name" then all_breweries.sort_by(&:name)
                      when "year" then all_breweries.sort_by(&:year)
                      when "beer_count" then all_breweries.sort_by{ |b| b.beers.count }.reverse
                      when "rating" then all_breweries.sort_by{ |b| b.average_rating || 0 }.reverse
                      else all_breweries.sort_by(&:name)
                      end
    
    @active_breweries = sorted_breweries.select(&:active)
    @retired_breweries = sorted_breweries.reject(&:active)

    @breweries = all_breweries

    respond_to do |format|
      format.html 
      format.json { render json: @breweries.as_json(methods: [:beer_count]) }
    end
  end

  # GET /breweries/1 or /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries or /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: "Brewery was successfully created." }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1 or /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: "Brewery was successfully updated." }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1 or /breweries/1.json
  def destroy
    @brewery.destroy!

    respond_to do |format|
      format.html { redirect_to breweries_path, status: :see_other, notice: "Brewery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (not brewery.active)

    new_status = brewery.active? ? "active" : "retired"

    redirect_to brewery, notice:"brewery activity status changed to #{new_status}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end

    def authenticate
      admin_accounts = { "pekka" => "beer", "arto" => "foobar", "matti" => "ittam", "vilma" => "kangas" }

      authenticate_or_request_with_http_basic do |username, password|
        admin_accounts[username] == password
      end
    end
    
  def expire_breweries_cache
    ["brewerylist-active-name", "brewerylist-active-year", 
    "brewerylist-active-beer_count", "brewerylist-active-rating",
    "brewerylist-retired-name", "brewerylist-retired-year",
    "brewerylist-retired-beer_count", "brewerylist-retired-rating"].each{ |f| expire_fragment(f) }
  end
end