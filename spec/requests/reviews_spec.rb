require 'rails_helper'

RSpec.describe "Reviews", type: :request do
    let(:user) {create(:user)}
    let(:user1) {create(:user)}
    let(:seller) {create(:seller, userable: user)}
    let(:deal) { create(:deal) }
    let(:buyer) {create(:buyer, userable: user1)}
    let!(:review) {create(:review,seller: seller, reviewer: buyer)}
    let(:application) { create(:oauth_application) }
    let(:token) do 
        user.reload 
        Doorkeeper::AccessToken.create!(
            resource_owner_id: user1.id, 
            application_id: application.id, 
            scopes: "public"
        ).token 
    end

    let(:headers) { {"Authorization" => "Bearer #{token}"}}

    describe("GET api/v1/reviews") do
        it "get all reviews" do
            get api_v1_reviews_path,headers: headers
            expect(response).to have_http_status(:ok)
        end
        it "show a review" do
            get api_v1_review_path(review),headers: headers
            expect(response).to have_http_status(:ok)
        end
        
    end

    describe ("DELETE API/V1/REVIEWS") do
        context "authorized to delete" do
            it "succefully deleted" do
                delete api_v1_review_path(review),headers: headers
                expect(response).to have_http_status(:ok)
            end
        end
        context "not authrized to delete" do
            let(:other_user) {create(:user)}
            let(:application) { create(:oauth_application) }
            let(:token) do 
                user.reload 
                Doorkeeper::AccessToken.create!(
                    resource_owner_id: other_user.id, 
                    application_id: application.id, 
                    scopes: "public"
                ).token 
            end

            let(:headers) { {"Authorization" => "Bearer #{token}"}}
            it "forbidden to delete" do
                delete api_v1_review_path(review),headers: headers
                expect(response).to have_http_status(:forbidden)
            end
        end
    end
    describe ("CREATE API/V1/REVIEWS") do
        context "authorized to CREATE" do
            let(:valid_params) do {
                review: {
                    rating: 4.3,
                    comment: "good",
                    seller_id: seller.id,
                    deal_id: deal.id
                }
            }
            end
            it "succefully created" do
                post api_v1_reviews_path,headers: headers,params: valid_params
                expect(response).to have_http_status(201)
            end
            
        end
    context "with invalid params" do
        let(:invalid_params) do 
            {
                review: {
                    rating: 10, # Invalid: must be 1..5
                    comment: "too high",
                    seller_id: seller.id,
                    deal_id: deal.id
                }
            }
        end

        it "returns unprocessable entity" do
            post api_v1_reviews_path, headers: headers, params: invalid_params
            expect(response).to have_http_status(:unprocessable_entity)
            
            json = JSON.parse(response.body)
            expect(json["errors"]).to include("Rating must be less than or equal to 5")
        end
    end
    end

        
    

end