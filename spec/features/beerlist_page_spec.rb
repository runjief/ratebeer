require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :cuprite do |app|
      Capybara::Cuprite::Driver.new(app, headless: true, window_size: [1920, 1080], timeout: 60)
    end

    Capybara.javascript_driver = :cuprite
    WebMock.disable_net_connect!(allow_localhost: true)
  end


  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows one known beer", js: true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Nikolai"
  end

  it "shows beers in alphabetical order by name", js: true do
    visit beerlist_path
    
    find('table').find('tr:nth-child(2)')
    
    rows = all('#beertable tbody tr')
    
    expect(rows[0].text).to have_content "Fastenbier"
    
    expect(rows[1].text).to have_content "Lechte Weisse"
    
    expect(rows[2].text).to have_content "Nikolai"
  end

  it "sorts beers by brewery when brewery heading is clicked", js: true do
    visit beerlist_path
    
    find('table').find('tr:nth-child(2)')
    
    find('#brewery').click
    
    sleep(0.5)
    
    rows = all('#beertable tbody tr')
    
    expect(rows[0].text).to have_content "Lechte Weisse"
    expect(rows[1].text).to have_content "Nikolai"
    expect(rows[2].text).to have_content "Fastenbier"
  end
end