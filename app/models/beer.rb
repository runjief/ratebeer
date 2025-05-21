class Beer < ApplicationRecord
  include RatingAverage
  belongs_to :brewery, touch: true
  belongs_to :style, optional: true
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user
  validates :name, presence: true
  validates :style, presence: true
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
  def self.top(n)
    sorted_by_rating = Beer.all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating.take(n)
  end
end
