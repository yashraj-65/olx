require 'rails_helper'

RSpec.describe "Admin::Buyers", type: :request do
  let!(:admin) { create(:admin_user) }
  # Create buyers that meet and don't meet the scope criteria
  let!(:frequent_buyer) { create(:buyer, purchase_count: 5, total_spent: 500) }
  let!(:new_buyer) { create(:buyer, purchase_count: 1, total_spent: 50) }

  before do
    sign_in admin
  end

  describe "Index Page" do
    it "renders the index table and covers index block columns" do
      get admin_buyers_path
      expect(response).to have_http_status(:success)
      
      # This ensures the code inside the 'index' columns is executed
      expect(response.body).to include(frequent_buyer.total_spent.to_s)
      expect(response.body).to include(frequent_buyer.purchase_count.to_s)
    end
  end

  describe "Scopes" do
    it "covers the 'more than 2 purchases' scope logic" do
      # Triggers the Buyer.where("purchase_count >= ?", 2) block
      get admin_buyers_path, params: { scope: "more_than_2_purchases" }
      
      expect(response.body).to include(frequent_buyer.id.to_s)
      expect(response.body).not_to include(new_buyer.id.to_s)
    end
  end

  describe "Filters" do
    it "filters by purchase count" do
      get admin_buyers_path, params: { q: { purchase_count_eq: 5 } }
      expect(response.body).to include(frequent_buyer.id.to_s)
    end
  end
end