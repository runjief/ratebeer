class Rating < ApplicationRecord
  belongs_to :beer
  belongs_to :user   # rating belongs to an user

  def to_s
    "#{beer.name} #{score}"
  end
end