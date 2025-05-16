# spec/features/places_spec.rb
require 'rails_helper'

describe "Places" do
  before :each do
    weather_response = {
      "current": {
        "temperature": 10,
        "weather_icons": ["https://example.com/icon.png"],
        "weather_descriptions": ["Cloudy"],
        "wind_speed": 10,
        "wind_dir": "N",
        "humidity": 70
      }
    }.to_json

    stub_request(:get, /api\.weatherstack\.com\/current/).
      to_return(body: weather_response, headers: { 'Content-Type' => 'application/json' })
  end

  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by the API, all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("helsinki").and_return(
      [
        Place.new(name: "Bruuveri", id: 1),
        Place.new(name: "Kaisla", id: 2),
        Place.new(name: "Pikkulintu", id: 3)
      ]
    )

    visit places_path
    fill_in('city', with: 'helsinki')
    click_button "Search"

    expect(page).to have_content "Bruuveri"
    expect(page).to have_content "Kaisla"
    expect(page).to have_content "Pikkulintu"
  end

  it "if none are returned by the API, a notice is shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("nowhere").and_return([])

    visit places_path
    fill_in('city', with: 'nowhere')
    click_button "Search"

    expect(page).to have_content "No locations in nowhere"
  end

  it "allows clicking on a place name to view details" do
    place = Place.new(
      id: "12411", 
      name: "Gallows Bird", 
      city: "Espoo", 
      status: "Brewery"
    )
    
    allow(BeermappingApi).to receive(:places_in).with("espoo").and_return([place])
    allow(BeermappingApi).to receive(:places_in).with(anything).and_call_original

    visit places_path
    fill_in('city', with: 'espoo')
    click_button "Search"

    click_link "Gallows Bird"

    expect(page).to have_content "Gallows Bird"
    expect(page).to have_content "Brewery"
  end
end