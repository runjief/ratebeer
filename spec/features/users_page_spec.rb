require 'rails_helper'
include Helpers
describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
        click_button('Create User')
    }.to change{User.count}.by(1)
    end
  end
  
  describe "ratings" do
    let!(:user1) { User.find_by(username: "Pekka") || FactoryBot.create(:user, username: "Pekka") }
    let!(:user2) { FactoryBot.create(:user, username: "Vilma", password: "Foobar1", password_confirmation: "Foobar1") }
    let!(:brewery) { FactoryBot.create(:brewery) }
    let!(:beer1) { FactoryBot.create(:beer, name: "Beer1", brewery: brewery) }
    let!(:beer2) { FactoryBot.create(:beer, name: "Beer2", brewery: brewery) }
    let!(:beer3) { FactoryBot.create(:beer, name: "Beer3", brewery: brewery) }
    
    before :each do
      # Create ratings for both users
      FactoryBot.create(:rating, score: 10, beer: beer1, user: user1)
      FactoryBot.create(:rating, score: 15, beer: beer2, user: user1)
      FactoryBot.create(:rating, score: 20, beer: beer3, user: user2)
      
      sign_in(username: "Pekka", password: "Foobar1")
    end
    
    it "shows user's own ratings on their page" do
      # Important: Use user_path(user1) instead of just user1
      visit user_path(user1)
      
      # Optionally use save_and_open_page to see what's on the page
      # save_and_open_page
      
      # Verify own ratings are shown
      expect(page).to have_content "Beer1 10"
      expect(page).to have_content "Beer2 15"
      
      # Verify others' ratings are not shown
      expect(page).not_to have_content "Beer3 20"
      
      # Verify the ratings count is correct
      expect(page).to have_content "Has made 2 ratings"
    end
    
    it "doesn't show other users' ratings on own page" do
      visit user_path(user2)
      
      # Verify user2's ratings are shown
      expect(page).to have_content "Beer3 20"
      
      # Verify user1's ratings are not shown
      expect(page).not_to have_content "Beer1 10"
      expect(page).not_to have_content "Beer2 15"
      
      # Verify the ratings count is correct
      expect(page).to have_content "Has made 1 rating"  # Note: singular "rating"
    end
  end

end

