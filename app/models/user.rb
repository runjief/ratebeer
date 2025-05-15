class User < ApplicationRecord
  include RatingAverage
  has_secure_password
  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 },
                      format: {
                        with: /\A(?=.*[A-Z])(?=.*\d).+\z/,
                        message: "must contain at least one uppercase letter and one number"
                      }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by(&:score).last.beer
  end

  def favorite_style
    return nil if ratings.empty?

    style_ratings = ratings.group_by{ |r| r.beer.style }

    style_averages = style_ratings.map do |style, ratings|
      { style: style, average: ratings.sum(&:score) / ratings.size.to_f }
    end

    style_averages.max_by{ |s| s[:average] }[:style]
  end

  def favorite_brewery
    return nil if ratings.empty?
    
    brewery_ratings = ratings.group_by{ |r| r.beer.brewery }
    
    brewery_averages = brewery_ratings.map do |brewery, ratings|
      { brewery: brewery, average: ratings.sum(&:score) / ratings.size.to_f }
    end

    brewery_averages.max_by{ |b| b[:average] }[:brewery]
  end
end
