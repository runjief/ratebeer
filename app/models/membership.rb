class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :beer_club

  validates :user_id, uniqueness: { scope: :beer_club_id, message: "is already a member of this club" }
  scope :confirmed, -> { where(confirmed: true) }
  scope :pending, -> { where(confirmed: false) }

  def confirm!
    update_attribute(:confirmed, true)
  end
end
