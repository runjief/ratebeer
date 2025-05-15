class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates :name, presence: true
  validates :founded, numericality: { only_integer: true }
  validates :city, presence: true
end
