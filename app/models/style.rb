class Style < ApplicationRecord
  include RatingAverage
  has_many :beers
  has_many :ratings, through: :beers
  validates :name, presence: true
  validates :description, presence: true
  # def self.top(n)
  #   sorted_by_rating = Style.all.sort_by do |s|
  #     beers = s.beers
  #     ratings = beers.flat_map(&:ratings)
      
  #     ratings.empty? ? 0 : -(ratings.sum(&:score) / ratings.size.to_f)
  #   end
    
  #   sorted_by_rating.take(n)
  # end

  def to_s
    name
  end
end