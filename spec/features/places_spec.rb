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
end