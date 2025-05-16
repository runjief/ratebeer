class AddFrozenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :frozen, :boolean, default: false
  end
end
