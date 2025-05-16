class AddStyleRefToBeers < ActiveRecord::Migration[6.1]
  def change
    rename_column :beers, :style, :old_style
    add_reference :beers, :style, foreign_key: true
  end
end