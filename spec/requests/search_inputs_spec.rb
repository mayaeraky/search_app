require 'rails_helper'

RSpec.describe "SearchInputs", type: :request do
  describe "POST /search_inputs" do
    it "creates a new search and returns results" do
      post "/search_inputs", params: { keyword: "This is a complete search" }.to_json, headers: {
        "CONTENT_TYPE" => "application/json"
      }

      expect(response).to have_http_status(:success)
      expect(SearchInput.last.keyword).to eq("This is a complete search")
      expect(response.body).to include("This is a complete search")
    end
  end
end