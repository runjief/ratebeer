require 'rails_helper'

RSpec.describe "Styles", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/styles/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/styles/show"
      expect(response).to have_http_status(:success)
    end
  end

end
