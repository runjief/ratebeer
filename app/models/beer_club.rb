class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :members, through: :memberships, source: :user

  has_many :confirmed_memberships, -> { where(confirmed: true) }, class_name: "Membership"
  has_many :confirmed_members, through: :confirmed_memberships, source: :user

  has_many :pending_memberships, -> { where(confirmed: false) }, class_name: "Membership"
  has_many :pending_members, through: :pending_memberships, source: :user

  validates :name, presence: true
  validates :founded, numericality: { only_integer: true }
  validates :city, presence: true
end
