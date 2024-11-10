require 'rails_helper'

RSpec.describe "CartsProducts", type: :request do
  describe "GET /delete" do
    it "returns http success" do
      get "/carts_products/delete"
      expect(response).to have_http_status(:success)
    end
  end

end
