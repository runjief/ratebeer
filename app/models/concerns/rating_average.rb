module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    # Count and save based on the fetched ratings objects (associated to a beer)
    rating_count = ratings.size
    
    return 0 if rating_count == 0
    ratings.map{ |r| r.score }.sum / rating_count
  end
end