class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :members, through: :memberships, source: :user
  validates :name, presence: true
  validates :founded, numericality: { only_integer: true }
  validates :city, presence: true
end
