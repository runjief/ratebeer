class RenameUserFrozenToAccountStatus < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :frozen, :account_status
  end
end
