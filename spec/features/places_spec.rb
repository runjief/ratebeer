require 'rails_helper'

describe "Places" do
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
    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>https://beermapping.com/location/12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    visit places_path
    fill_in('city', with: 'espoo')
    click_button "Search"

    click_link "Gallows Bird"
    expect(page).to have_content "Gallows Bird"
    expect(page).to have_content "Merituulentie 30"
    expect(page).to have_content "Brewery"
  end
end