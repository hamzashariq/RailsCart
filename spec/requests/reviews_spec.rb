require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/reviews/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/reviews/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/reviews/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
