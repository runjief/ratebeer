class AddConfirmedToMemberships < ActiveRecord::Migration[8.0]
  def change
    add_column :memberships, :confirmed, :boolean, default: false
  end
end