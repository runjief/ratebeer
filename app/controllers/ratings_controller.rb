class RatingsController < ApplicationController
  def create
    ["brewerylist-active"].each{ |f| expire_fragment(f) }
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end
  def index
    @ratings = Rating.all
    @recent_ratings = Rating.recent
    @top_beers = Rails.cache.fetch("beer_top_3", expires_in: 10.minutes) do
      Beer.top(3)
    end
    @top_breweries = Rails.cache.fetch("brewery_top_3", expires_in: 10.minutes) do
      Brewery.top(3)
    end
    @top_styles = Rails.cache.fetch("style_top_3", expires_in: 10.minutes) do
      Style.top(3)
    end
    @most_active_users = Rails.cache.fetch("user_top_3", expires_in: 10.minutes) do
      User.most_active(3)
    end

    respond_to do |format|
      format.html { } # render default template
      format.json { render json: @ratings }
    end

  end
  def new
    @rating = Rating.new
    @beers = Beer.all
  end
  def destroy
    ["brewerylist-active"].each{ |f| expire_fragment(f) }
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
