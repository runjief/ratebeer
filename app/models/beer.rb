class Beer < ApplicationRecord
  include RatingAverage
  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  def to_s
    "#{name} (#{brewery.name})"
  end
  # def average_rating
  #   ratings.reduce(0.0) { |sum, rating| sum + rating.score } / ratings.count
  # end
end