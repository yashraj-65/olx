require 'rails_helper'

RSpec.describe "Admin::Items", type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:seller_user) { create(:user, name: "John Doe") }
  let!(:seller) { create(:seller, userable: seller_user) } 
  let!(:category) { create(:category, kind: :electronics) } 
  let!(:item) { create(:item, title: "MacBook", status: :sold, seller: seller) }

  before do
    sign_in admin
  end

  describe "Batch Actions" do
    it "make avail" do
      post batch_action_admin_items_path, params: {
        batch_action: 'make_avail',
        collection_selection: [item.id]
      }
      expect(item.reload.status).to eq('available')
      expect(response).to redirect_to(admin_items_path)
    end

    it "covers the 'add_category' block" do
      post batch_action_admin_items_path, params: {
        batch_action: 'add_category',
        collection_selection: [item.id.to_s],
        batch_action_inputs: { "category_id": category.id }.to_json
      }
      item.reload
      expect(item.categories).to include(category)
      expect(flash[:notice]).to eq("Category added to selected items.")
    end
  end

  describe "Scopes" do
    it " category scopes " do
      item.categories << category
      get admin_items_path, params: { scope: 'Electronics' }
      expect(response.body).to include("MacBook")
    end

    it " available and sold scopes" do
      get admin_items_path, params: { scope: 'sold' }
      expect(response.body).to include("MacBook")
    end
  end

  describe "Filters" do
    it "covers the custom seller name filter" do
      get admin_items_path, params: { q: { seller_userable_of_User_type_name_cont: "John" } }
      expect(response.body).to include("MacBook")
    end

    it "covers the category kind filter" do
      get admin_items_path, params: { q: { categories_kind_eq: category.read_attribute_before_type_cast(:kind) } }
      expect(response).to have_http_status(:success)
    end
  end

  describe "Index and Form Rendering" do
    it "covers the custom index column blocks" do
      item.categories << category
      get admin_items_path
      expect(response.body).to include("electronics")
    end

    it "covers the form block" do
      get edit_admin_item_path(item)
      expect(response.body).to include("Item Details")
      expect(response.body).to include("Specifications")
    end
  end
end