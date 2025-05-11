class RatingsController < ApplicationController
  def create
    Rating.create params.require(:rating).permit(:score, :beer_id)
    redirect_to ratings_path
  end
  def index
    @ratings = Rating.all
  end
  def new
    @rating = Rating.new
    @beers = Beer.all
  end

end