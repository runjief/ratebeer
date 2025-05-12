class User < ApplicationRecord
  include RatingAverage
  
  has_many :ratings   # user has many ratings
end