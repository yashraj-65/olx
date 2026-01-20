require 'rails_helper'

RSpec.describe "Api::V1::Likes", type: :request do
  let(:user) { create(:user) }
  let!(:buyer) { user.buyer }
  let(:item) { create(:item) } 
  let!(:existing_like) { create(:like, buyer: buyer, likeable: item) }
  
  let(:application) { create(:oauth_application) }
  let(:token) do 
    Doorkeeper::AccessToken.create!(
        resource_owner_id: user.id, 
        application_id: application.id, 
        scopes: "public"
    ).token 
  end
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /api/v1/likes" do
    it "returns a list of likes" do
      get api_v1_likes_path, headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/v1/likes" do
    context "with valid parameters" do
      it "creates a new like" do
        new_item = create(:item) 
        valid_params = {
          like: {
            likeable_id: new_item.id,
            likeable_type: "Item"
          }
        }
        
        post api_v1_likes_path, params: valid_params, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("succesfully created like")
      end
    end

    context "when a duplicate like exists (triggering 422)" do
      it "returns unprocessable entity" do
        duplicate_params = {
          like: {
            likeable_id: item.id,
            likeable_type: "Item"
          }
        }

        post api_v1_likes_path, params: duplicate_params, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Buyer has already been taken")
      end
    end

    context "with missing parameters" do
      it "returns 400 bad request" do

        post api_v1_likes_path, params: { foo: "bar" }, headers: headers
      end
    end
  end
end