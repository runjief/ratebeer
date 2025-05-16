class Brewery < ApplicationRecord
  include RatingAverage
  has_many :beers, dependent: :destroy

  has_many :ratings, through: :beers
  validates :name, presence: true
  validates :year, numericality: {
    greater_than_or_equal_to: 1040,
    less_than_or_equal_to: -> { Time.now.year },
    only_integer: true
  }
  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }
  def print_report
    puts self.name
    puts "established at year #{self.year}"
    puts "number of beers #{self.beers.count}"
  end

  def restart
    self.year = 2025
    puts "changed year to #{year}"
  end

  def self.top(n)
    sorted_by_rating = Brewery.all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating.take(n)
  end
end
