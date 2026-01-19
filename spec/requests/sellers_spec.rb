require 'rails_helper'

RSpec.describe "Sellers", type: :request do
    let(:user) { create(:user) }
    
    let(:item) {create(:item, seller: seller)}
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
    describe "index action " do
        before do
            user1 = create(:user, name: "Alice")
            user2 = create(:user, name: "Bob")
            @seller1=create(:seller, userable: user1)
            @seller2=create(:seller, userable: user2)
        end

        it "retrieves all sellers " do
            get api_v1_sellers_path, headers: headers
            expect(response).to have_http_status(:ok)
        end
         it "retrieves single sellers " do
            get api_v1_seller_path(@seller1), headers: headers
            expect(response).to have_http_status(:ok)
        end
        
    end

    describe "update" do
        context "authorized to update" do
            let(:other_user) {create(:user)}
            let(:other_seller) {create(:seller, userable: other_user)}
            let(:valid_params) do {
                seller: {
                    avg_rating: "4.3",
                   
                }
            }
             end
            it "updated succefully" do
                my_seller = user.seller
                patch api_v1_seller_path(my_seller),headers: headers,params: valid_params
                expect(response).to have_http_status(:ok)
            end
            it "updated forbidden" do
                patch api_v1_seller_path(other_seller),headers: headers,params: valid_params
                expect(response).to have_http_status(:forbidden)
            end
            context "not authorized " do
                let(:invalid_params) do{
                    seller:{
                        avg_rating: "10.0"
                    }
                }
                end
                it "unprocessible" do
                    my_seller = user.seller
                    patch api_v1_seller_path(my_seller),headers: headers,params: invalid_params
                    expect(response).to have_http_status(:unprocessable_entity)
                end
            end

        end
        
    end
end