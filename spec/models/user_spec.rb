require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

    describe "with too short password" do
    let(:user) { User.create username: "Pekka", password: "Se1", password_confirmation: "Se1" }

    it "is not saved" do
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "with a password containing only letters" do
    let(:user) { User.create username: "Pekka", password: "Secret", password_confirmation: "Secret" }

    it "is not saved" do
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end
  describe "favorite beer" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end
    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end
    it "is the one with highest rating if several rated" do
        create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
        best = create_beer_with_rating({ user: user }, 25)

        expect(user.favorite_beer).to eq(best)
    end
  end
  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style with highest average rating if several rated" do
      create_beer_with_style_and_rating({ user: user }, "Lager", 10)
      create_beer_with_style_and_rating({ user: user }, "Lager", 20)
      create_beer_with_style_and_rating({ user: user }, "IPA", 25)
      create_beer_with_style_and_rating({ user: user }, "IPA", 15)
      create_beer_with_style_and_rating({ user: user }, "Porter", 30)

      expect(user.favorite_style).to eq("Porter")
    end
  end


  describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining favorite brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the brewery with highest average rating if several rated" do
      brewery1 = FactoryBot.create(:brewery, name: "Brewery1")
      brewery2 = FactoryBot.create(:brewery, name: "Brewery2")

      beer1 = FactoryBot.create(:beer, brewery: brewery1)
      beer2 = FactoryBot.create(:beer, brewery: brewery1)
      beer3 = FactoryBot.create(:beer, brewery: brewery2)
      beer4 = FactoryBot.create(:beer, brewery: brewery2)

      FactoryBot.create(:rating, beer: beer1, score: 10, user: user)
      FactoryBot.create(:rating, beer: beer2, score: 20, user: user)
      FactoryBot.create(:rating, beer: beer3, score: 30, user: user)
      FactoryBot.create(:rating, beer: beer4, score: 40, user: user)

      # Brewery1 avg: 15, Brewery2 avg: 35
      expect(user.favorite_brewery).to eq(brewery2)
    end
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: user)
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

def create_beer_with_style_and_rating(object, style, score)
  beer = FactoryBot.create(:beer, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end
