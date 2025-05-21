json.extract! brewery, :id, :name, :year, :active
json.beer_count brewery.beers.count
json.url brewery_url(brewery, format: :json)