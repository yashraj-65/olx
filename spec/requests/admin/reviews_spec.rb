require 'rails_helper'

RSpec.describe "Admin::Reviews", type: :request do
  let!(:admin) { create(:admin_user) }
  
  let!(:buyer_user) { create(:user, name: "Buyer Name") }
  let!(:buyer) { create(:buyer, userable: buyer_user) }
  let!(:seller_user) { create(:user, name: "Seller Name") }
  let!(:seller) { create(:seller, userable: seller_user) }
  let!(:deal) { create(:deal, agreed_price: 100) }
  
  let!(:review) do 
    create(:review, 
      rating: 4, 
      comment: "Great service", 
      reviewer: buyer, 
      seller: seller, 
      deal: deal
    ) 
  end

  before do
    sign_in admin
  end

  describe "Index page" do
    it "renders the index table and custom columns" do
      get admin_reviews_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Great service")
      expect(response.body).to include("Buyer Name")
    end
  end

  describe "Batch Actions" do
    it "updates ratings via edit_rating" do
      post batch_action_admin_reviews_path, params: {
        batch_action: 'edit_rating',
        collection_selection: [review.id.to_s],
        batch_action_inputs: { "new_rating" => "5" }.to_json
      }
      
      expect(review.reload.rating).to eq(5.0)
      expect(flash[:notice]).to include("Selected reviews updated to 5.0 stars.")
    end
  end

  describe "Scopes" do
    it "covers 'Highly Rated' scope" do
      get admin_reviews_path, params: { scope: "highly_rated" }
      expect(response.body).to include("Great service")
    end
  end

  describe "Filters" do
    it "filters reviews by rating" do
      get admin_reviews_path, params: { q: { rating_eq: 4 } }
      expect(response.body).to include("Great service")
    end
  end

  describe "Form" do
    it "renders the new/edit form and triggers dropdown maps" do
      get new_admin_review_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Buyer Name")
      expect(response.body).to include("Seller Name")
      expect(response.body).to include("Deal #")
    end
  end
end