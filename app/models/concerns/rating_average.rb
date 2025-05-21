module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?
    ratings.average(:score).to_f.round(1)
  end

  class_methods do
    def top(how_many)
      sorted_by_rating_in_desc_order = all.sort_by{ |b| -(b.average_rating || 0) }
      sorted_by_rating_in_desc_order[0, how_many]
    end
  end
end