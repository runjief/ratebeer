class UpdateRatingCacheJob
  include SuckerPunch::Job

  def perform
    Rails.cache.write("beer_top_3", Beer.top(3))
    Rails.cache.write("style_top_3", Style.top(3))
    Rails.cache.write("brewery_top_3", Brewery.top(3))
    Rails.cache.write("user_top_3", User.top(3))
    
    # Schedule the job to run again in 10 minutes
    UpdateRatingCacheJob.perform_in(10.minutes)
  end
end