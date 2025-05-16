
class WeatherApi
  def self.current(city)
    city = city.downcase
    
    weather = Rails.cache.read("weather_#{city}")
    return weather if weather
    
    url = "http://api.weatherstack.com/current"
    
    response = HTTParty.get(url, query: {
      access_key: api_key,
      query: ERB::Util.url_encode(city)
    })
    
    return nil if response["error"]
    
    weather_data = response["current"]
    weather = {
      temperature: weather_data["temperature"],
      weather_icons: weather_data["weather_icons"],
      weather_descriptions: weather_data["weather_descriptions"],
      wind_speed: weather_data["wind_speed"],
      wind_dir: weather_data["wind_dir"],
      humidity: weather_data["humidity"]
    }
    
    Rails.cache.write("weather_#{city}", weather, expires_in: 30.minutes)
    
    weather
  end
  
  def self.api_key
    return nil if Rails.env.test? 
    raise "WEATHERSTACK_API_KEY environment variable not defined" if ENV['WEATHERSTACK_API_KEY'].nil?
    ENV['WEATHERSTACK_API_KEY']
  end
end