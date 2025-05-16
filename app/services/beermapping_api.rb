class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { get_places_in(city) }
    # Rails.cache.fetch(city, expires_in: 1.minute) { get_places_in(city) }
  end

  def self.get_places_in(city)
    url = "https://studies.cs.helsinki.fi/beermapping/locations/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end
  def self.place_with_id(id)
    places = Rails.cache.read("places")
    return nil if places.nil?
    places.find { |place| place.id == id }
  end

  def self.places_in(city)
    city = city.downcase
    places = Rails.cache.fetch(city, expires_in: 1.week) { get_places_in(city) }

    Rails.cache.write("places", places)
    
    places
  end

end