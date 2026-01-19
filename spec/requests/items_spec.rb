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

  let(:headers) { {"Authorization" => "Bearer #{token}"}}

    describe "GET /api/v1/items" do
        it "returns a list of items" do
          get api_v1_items_path, headers: headers
          expect(response).to have_http_status(200)
        end
        it "returns a single item" do
          get api_v1_item_path(my_item),headers: headers
          expect(response).to have_http_status(:ok)
        end

    end

      describe "POST  /api/v1/items" do
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
            context "when authenticatied" do
              it "creates a new item" do      
                  post api_v1_items_path, params: valid_params, headers: headers
                  expect(response).to have_http_status(201)

                  expect(Item.last.title).to eq("First Item")
                  expect(Item.last.seller_id).to eq(user.seller.id)
              end
            end
            context "not authorized" do
                  it "returns unauthorized" do
                    post api_v1_items_path, params: valid_params 
                    expect(response).to have_http_status(:unauthorized)
                  end
            end
      end
        describe "Delete /api/v1/item/:id" do
          context "when user owns the  item" do
            it "deletes the item" do
              delete api_v1_item_path(my_item), headers: headers
                puts "RESPONSE BODY: #{response.body}"
              expect(response).to have_http_status(:ok)
            end
          end
          context "when user doesnt own the item" do

            it " returns forbidden" do
          other_owner = create(:user, email: "other@example.com")
          other_seller = create(:seller, userable: other_owner)
          unauthorized_item = create(:item, seller: other_seller)
              delete api_v1_item_path(unauthorized_item),headers: headers
            
              expect(response).to have_http_status(:forbidden)
              
            end
          end
        end

      describe "Patch /api/v1/item/id" do
          let(:edit_params) do
            {
              item: {
                title: "Changed Title"
              }
            }
          end

          context "when user edits their own item" do
            it "updates the item and returns success" do

              patch api_v1_item_path(my_item), params: edit_params, headers: headers        
              expect(response).to have_http_status(:ok)
            end
          end
          context "when user edits other  users item" do
          let(:invalid_params) do 
            { 
              item: { title: "" } 
            } 
          end
            
            it "returns forbidden" do
                other_owner = create(:user, email: "other@example.com")
                other_seller = create(:seller, userable: other_owner)
                unauthorized_item = create(:item, seller: other_seller)
              patch api_v1_item_path(unauthorized_item), params: edit_params, headers: headers
              
              expect(response).to have_http_status(:forbidden)
            end
            it "return unprocessible entity" do
                patch api_v1_item_path(my_item),headers: headers,params: invalid_params
                expect(response).to have_http_status(:unprocessable_entity)
            end
          end

      end
    describe "search and filter api" do
    context "search based on query" do
        it "return item based on query" do
          item = create(:item, title: "Vintage Camera", seller: my_seller)
          item.categories << category

          get "/api/v1/items/search_by_query", 
          params: { query: "vintage", category_id: category.id }, 
          headers: headers

          expect(response).to have_http_status(:ok)

        end
    end
    context "search based on category" do
        it "return item based on category" do
          item = create(:item, title: "Vintage Camera", seller: my_seller)
          item.categories << category

          get "/api/v1/items/search_by_category", 
          params: {  category_id: category.id }, 
          headers: headers

          expect(response).to have_http_status(:ok)

        end
    end
  end

end
