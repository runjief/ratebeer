class Beer < ApplicationRecord
  include RatingAverage
  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  validates :name, presence: true
  def to_s
    "#{name} (#{brewery.name})"
  end
  # def average_rating
  #   ratings.reduce(0.0) { |sum, rating| sum + rating.score } / ratings.count
  # end
  def average
    return 0 if ratings.empty?
    ratings.map { |r| r.score }.sum / ratings.count.to_f
  end
end
