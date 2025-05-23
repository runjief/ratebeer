class BeersController < ApplicationController
  before_action :set_beer, only: %i[ show edit update destroy ]
  before_action :set_breweries, only: %i[ new edit create update ]
  before_action :set_breweries_and_styles_for_template, only: [ :new, :edit, :create ]
  before_action :ensure_that_signed_in, except: [ :index, :show,  :list ]
  before_action :ensure_that_admin, only: [:destroy]
  # GET /beers or /beers.json
  def index
    @order = params[:order] || 'name'
    return if request.format.html? && fragment_exist?("beerlist-#{@order}")

    @beers = Beer.includes(:brewery, :style, :ratings).all
    @beers = case @order
              when 'name' then @beers.sort_by(&:name)
              when 'brewery' then @beers.sort_by{ |b| b.brewery.name }
              when 'style' then @beers.sort_by{ |b| b.style.name }
              end
  end
  def list
  end
  # GET /beers/1 or /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  # GET /beers/new
  def new
    @beer = Beer.new
    @breweries = Brewery.all
    @styles = Style.all
  end

  # GET /beers/1/edit
  def edit
    @breweries = Brewery.all
    @styles = Style.all
  end

  # POST /beers or /beers.json
  def create
    ["beerlist-name", "beerlist-brewery", "beerlist-style"].each{ |f| expire_fragment(f) }
    @beer = Beer.new(beer_params)

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: "Beer was successfully created." }
        format.json { render :show, status: :created, location: @beer }
      else
        @breweries = Brewery.all
        @styles = [ "Weizen", "Lager", "Pale ale", "IPA", "Porter", "Lowalcohol" ]
        format.html { render :new }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /beers/1 or /beers/1.json
  def update
    ["beerlist-name", "beerlist-brewery", "beerlist-style"].each{ |f| expire_fragment(f) }
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: "Beer was successfully updated." }
        format.json { render :show, status: :ok, location: @beer }
      else
        @breweries = Brewery.all
        @styles = Style.all
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1 or /beers/1.json
  def destroy
    ["beerlist-name", "beerlist-brewery", "beerlist-style"].each{ |f| expire_fragment(f) }
    @beer.destroy!

    respond_to do |format|
      format.html { redirect_to beers_path, status: :see_other, notice: "Beer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer
      @beer = Beer.find(params[:id])  # Fixed the typo from 'expect' to ':id'
    end

    # Set up breweries for dropdown list
    def set_breweries
      @breweries = Brewery.all
    end

    # Only allow a list of trusted parameters through.
    def beer_params
      params.require(:beer).permit(:name, :brewery_id, :style_id)
    end

    def set_breweries_and_styles_for_template
      @breweries = Brewery.all
      @styles = [ "Weizen", "Lager", "Pale ale", "IPA", "Porter", "Lowalcohol" ]
    end
end
