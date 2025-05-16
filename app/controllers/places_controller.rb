class PlacesController < ApplicationController
  def index
  end
  def show
    @place = BeermappingApi.place_with_id(params[:id])
    
    if @place.nil?
      redirect_to places_path, notice: "Restaurant not found"
    end
  end
  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:last_city] = params[:city]
      render :index, status: 418
    end
  end

  private

  def find_place_by_id(id)
    return nil if session[:last_city].nil?
    places = BeermappingApi.places_in(session[:last_city])
    places.find { |place| place.id == id }
  end
end