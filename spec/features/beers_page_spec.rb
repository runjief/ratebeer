require 'rails_helper'
include Helpers

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "is created when given a valid name" do
    visit new_beer_path
    fill_in('beer[name]', with: 'Test Beer')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "is not created and returns to new beer page when name is invalid" do
    visit new_beer_path
    fill_in('beer[name]', with: '')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.by(0)
    
    expect(page).to have_content "Name can't be blank"
    expect(current_path).to eq(beers_path)
  end
end