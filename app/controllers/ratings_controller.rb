class RatingsController < ApplicationController
  def create
    rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    rating.user = current_user
    rating.save
    redirect_to current_user
  end
  def index
    @ratings = Rating.all
  end
  def new
    @rating = Rating.new
    @beers = Beer.all
  end
  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to ratings_path
  end
end
