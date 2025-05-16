require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "with a brewery and style" do
    let(:test_brewery) { Brewery.create name: "test", year: 2000 }
    let(:test_style) { Style.create name: "Teststyle", description: "Test description" }

    it "is saved when name, style, and brewery are set" do
      beer = Beer.create name: "Testbeer", style: test_style, brewery: test_brewery
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "is not saved without a name" do
      beer = Beer.create style: test_style, brewery: test_brewery
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "is not saved without a style" do
      beer = Beer.create name: "Testbeer", brewery: test_brewery
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end