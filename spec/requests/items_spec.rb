require 'rails_helper'

RSpec.describe "Items", type: :request do
  let(:user) { create(:user) }
  let(:my_seller) { user.seller }
  let!(:my_item) { create(:item, seller: my_seller) }
  let!(:category) { Category.create!(kind: :electronics) }
  let(:application) { create(:oauth_application) }

  let(:token) do 
    user.reload 
    Doorkeeper::AccessToken.create!(
      resource_owner_id: user.id, 
      application_id: application.id, 
      scopes: "public"
    ).token 
  end

  let(:headers) { {"Authorization" => "Bearer #{token}"} }

  let(:user_without_seller) { create(:user) }
  let(:token_no_seller) do
    user_without_seller.reload
    Doorkeeper::AccessToken.create!(
      resource_owner_id: user_without_seller.id,
      application_id: application.id,
      scopes: "public"
    ).token
  end
  let(:headers_no_seller) { {"Authorization" => "Bearer #{token_no_seller}"} }

  let(:valid_params) do 
    { 
      item: { 
        title: "First Item", 
        desc: "This is a description", 
        price: 200, 
        color: "red",
        condition: "brand_new", 
        status: "available"
      } 
    }
  end

  let(:edit_params) do
    {
      item: {
        title: "Changed Title"
      }
    }
  end

  let(:invalid_params) do 
    { 
      item: { title: "" } 
    } 
  end

  describe "GET /api/v1/items" do
    it "returns a list of items" do
      get api_v1_items_path, headers: headers
      expect(response).to have_http_status(200)
    end

    it "returns a single item" do
      get api_v1_item_path(my_item), headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/v1/items" do
    context "when authenticated" do
      it "sets the seller_id from the current user" do
        expect(user.seller).to be_present 
        post api_v1_items_path, params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
        expect(Item.last.seller_id).to eq(user.seller.id)
      end

      it "returns unprocessable entity when save fails" do
        allow_any_instance_of(Item).to receive(:save).and_return(false)
        post api_v1_items_path, params: valid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "sets seller_id to nil when seller association is mocked nil" do
        allow_any_instance_of(User).to receive(:seller).and_return(nil)
        post api_v1_items_path, params: valid_params, headers: headers_no_seller
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        post api_v1_items_path, params: valid_params 
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/items/:id" do
    context "when user owns the item" do
      it "deletes the item" do
        delete api_v1_item_path(my_item), headers: headers
        expect(response).to have_http_status(:ok)
        expect(Item.find_by(id: my_item.id)).to be_nil
      end
    end

    context "when user does not own the item" do
      it "returns forbidden" do
        other_owner = create(:user, email: "other@example.com")
        other_seller = create(:seller, userable: other_owner)
        unauthorized_item = create(:item, seller: other_seller)
        
        delete api_v1_item_path(unauthorized_item), headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when user has no seller" do
      it "returns forbidden" do
        delete api_v1_item_path(my_item), headers: headers_no_seller
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when current_user is mocked as nil" do
      it "returns forbidden" do
        allow_any_instance_of(Api::V1::ItemsController).to receive(:current_user).and_return(nil)
        delete api_v1_item_path(my_item), headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH /api/v1/items/:id" do
    context "when user edits their own item" do
      it "updates the item and returns success" do
        patch api_v1_item_path(my_item), params: edit_params, headers: headers        
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user edits another user's item" do
      it "returns forbidden" do
        other_owner = create(:user, email: "other@example.com")
        other_seller = create(:seller, userable: other_owner)
        unauthorized_item = create(:item, seller: other_seller)
        
        patch api_v1_item_path(unauthorized_item), params: edit_params, headers: headers
        expect(response).to have_http_status(:forbidden)
      end

      it "returns unprocessable entity with invalid params" do
        patch api_v1_item_path(my_item), headers: headers, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when item seller has no userable association" do
      it "returns forbidden when seller.userable_id is nil" do
        allow_any_instance_of(Seller).to receive(:userable_id).and_return(nil)
        patch api_v1_item_path(my_item), params: edit_params, headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        patch api_v1_item_path(my_item), params: edit_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "Search and filter endpoints" do
    context "search by query" do
      it "returns items matching the query" do
        item = create(:item, title: "Vintage Camera", seller: my_seller)
        item.categories << category

        get "/api/v1/items/search_by_query", 
            params: { query: "vintage", category_id: category.id }, 
            headers: headers
        expect(response).to have_http_status(:ok)
      end

      it "returns empty list when query matches no items" do
        get "/api/v1/items/search_by_query",
            params: { query: "nonexistent_product_xyz" },
            headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context "search by category" do
      it "returns items in the category" do
        item = create(:item, title: "Vintage Camera", seller: my_seller)
        item.categories << category

        get "/api/v1/items/search_by_category", 
            params: { category_id: category.id }, 
            headers: headers
        expect(response).to have_http_status(:ok)
      end

      it "returns empty list for category with no items" do
        empty_category = Category.create!(kind: :furniture)
        
        get "/api/v1/items/search_by_category",
            params: { category_id: empty_category.id },
            headers: headers
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "Index action with pagination" do
    it "returns correct pagination metadata" do
      (1..15).each { |i| create(:item, seller: my_seller, title: "Item #{i}") }
      
      get api_v1_items_path, headers: headers
      expect(response).to have_http_status(200)
      
      json_response = JSON.parse(response.body)
      expect(json_response['pagination']).to include('count', 'pages', 'current_page', 'items_per_page')
    end
  end
end
