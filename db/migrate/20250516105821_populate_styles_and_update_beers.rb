class PopulateStylesAndUpdateBeers < ActiveRecord::Migration[6.1]
  def up
    style_names = Beer.distinct.pluck(:old_style)
    
    style_names.each do |name|
      next if name.blank?
      Style.create!(
        name: name,
        description: "Description for #{name} style."
      )
    end
    
    Beer.all.each do |beer|
      next if beer.old_style.blank?
      style = Style.find_by(name: beer.old_style)
      beer.update_column(:style_id, style.id) if style
    end
  end

  def down
    Beer.all.each do |beer|
      next unless beer.style
      beer.update_column(:old_style, beer.style.name)
      beer.update_column(:style_id, nil)
    end
    
    Style.destroy_all
  end
end