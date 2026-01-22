require 'rails_helper'

RSpec.describe "Deals", type: :request do
    let(:user_seller) { create(:user) }
    let(:user_buyer) { create(:user) }
    let(:seller) { user_seller.seller }
    let(:buyer) { user_buyer.buyer }
    
    let(:item) { create(:item, seller: seller) }
    let(:conversation) { create(:conversation, seller_profile: seller, buyer_profile: buyer) }
    let!(:deal) do
      create(
        :deal,
        item: item,
        conversation: conversation,
        seller: seller,
        buyer: buyer,
        proposer: user_seller
      )
    end

    
    let(:application) { create(:oauth_application) }
    let(:token) do 
    Doorkeeper::AccessToken.create!(
        resource_owner_id: user_seller.id, 
        application_id: application.id, 
        scopes: "public" 
    ).token 
    end
    let(:headers) { { "Authorization" => "Bearer #{token}" } }

    describe "GET API/V1/DEALS" do
        it "get all deals" do
            get api_v1_deals_path, headers: headers
            expect(response).to have_http_status(:ok)
        end
        it "show a deal" do
            get api_v1_deal_path(deal), headers: headers
            expect(response).to have_http_status(:ok)
            
        end
    end
    describe "PATCH API/V1/DEALS/MARKSOLD" do

        it "successfully marks the deal as sold for the seller" do

          patch mark_sold_api_v1_deal_path(deal), headers: headers
          
          expect(response).to have_http_status(:ok)
          expect(deal.reload.seller_marked_done).to be true
        end
        
        context "buyer marking done" do
                
            let(:application) { create(:oauth_application) }
            let(:token) do 
            Doorkeeper::AccessToken.create!(
                resource_owner_id: user_buyer.id, 
                application_id: application.id, 
                scopes: "public" 
            ).token 
            end
            let(:headers) { { "Authorization" => "Bearer #{token}" } }
            let!(:new_deal) do
              create(
                :deal,
                item: item,
                conversation: conversation,
                seller: seller,
                buyer: buyer,
                proposer: user_seller
              )
            end
            it "successfully marks the deal as sold for the buyer" do

              patch mark_sold_api_v1_deal_path(new_deal), headers: headers
              
              expect(response).to have_http_status(:ok)
              expect(new_deal.reload.buyer_marked_done).to be true
            end
            
        end

        context "when an unauthorized user tries to mark as sold" do
          let(:other_user) { create(:user) }
          let(:other_token) do 
            Doorkeeper::AccessToken.create!(
              resource_owner_id: other_user.id, 
              application_id: application.id, 
              scopes: "public" 
            ).token 
          end
          let(:other_headers) { { "Authorization" => "Bearer #{other_token}" } }

          it "returns forbidden status" do
            patch mark_sold_api_v1_deal_path(deal), headers: other_headers       
            expect(response).to have_http_status(:forbidden)
          end
        end

      end
describe "PATCH /api/v1/deals/:id" do
  let(:valid_params) { { deal: { agreed_price: 250.0 } } }

  # PATH 1: Authorized as Seller (First part of || is true)
  context "when authorized as the seller" do
    it "updates the deal successfully" do
      patch api_v1_deal_path(deal), params: valid_params, headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  # PATH 2: Authorized as Buyer (First part is false, second part is true)
  context "when authorized as the buyer" do
    let(:buyer_token) do 
      Doorkeeper::AccessToken.create!(
        resource_owner_id: user_buyer.id, 
        application_id: application.id, 
        scopes: "public"
      ).token 
    end
    let(:buyer_headers) { { "Authorization" => "Bearer #{buyer_token}" } }

    it "updates the deal successfully" do
      patch api_v1_deal_path(deal), params: valid_params, headers: buyer_headers
      expect(response).to have_http_status(:ok)
    end
  end

  # PATH 3: Unauthorized (Both parts of || are false - Hits the 'return')
  context "when unauthorized (different user)" do
    let(:random_user) { create(:user) }
    let(:random_token) do 
      Doorkeeper::AccessToken.create!(
        resource_owner_id: random_user.id, 
        application_id: application.id,
        scopes: "public"
      ).token 
    end
    let(:random_headers) { { "Authorization" => "Bearer #{random_token}" } }

    it "returns forbidden and hits the unauthorized return branch" do
      patch api_v1_deal_path(deal), params: valid_params, headers: random_headers
      
      expect(response).to have_http_status(:forbidden)
      expect(JSON.parse(response.body)["message"]).to eq("unauthorized")
    end
  end

  # UNHAPPY PATH: Authorization passes, but validation fails
  context "when update fails validation" do
    it "returns unprocessable_entity" do
      # Triggering the 'else' branch of the @deal.update(item_params)
      patch api_v1_deal_path(deal), params: { deal: { agreed_price: -1 } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
end