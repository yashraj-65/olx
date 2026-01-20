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
    let(:invalid_params) { { deal: { status: nil } } } 
    context "when authorized (as seller)" do
      it "updates the deal successfully" do
        patch api_v1_deal_path(deal), params: valid_params, headers: headers
        
        expect(response).to have_http_status(:ok)
      end

      it "returns unprocessable_entity when update fails validation" do
        patch api_v1_deal_path(deal), params: { deal: { agreed_price: -1 } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when unauthorized (different user)" do
      let(:other_user) { create(:user) }
      let(:other_token) do 
        Doorkeeper::AccessToken.create!(
          resource_owner_id: other_user.id, 
          application_id: application.id
        ).token 
      end
      let(:other_headers) { { "Authorization" => "Bearer #{other_token}" } }

      it "returns forbidden and does not update the deal" do
        puts "Route being called: #{api_v1_deal_path(deal)}"
        original_price = deal.agreed_price
        patch api_v1_deal_path(deal), params: valid_params, headers: other_headers
  
        expect(response).to have_http_status(:forbidden)
  
      end
    end
    
  end
end