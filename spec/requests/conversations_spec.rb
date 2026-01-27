require 'rails_helper'

RSpec.describe "Api::V1::Conversations", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  
  let(:my_seller_profile) { user.seller }
  let(:my_buyer_profile) { user.buyer }
  let(:other_buyer_profile) {  other_user.buyer }

  let!(:conv_as_seller) { create(:conversation, seller_profile: my_seller_profile, buyer_profile: other_buyer_profile) }
  let!(:conv_as_buyer) { create(:conversation, buyer_profile: my_buyer_profile) }
  let!(:stranger_conv) { create(:conversation) } 

  let(:application) { create(:oauth_application) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, scopes: "public").token }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /api/v1/conversations" do
        it "returns only conversations involving the current user" do
          get api_v1_conversations_path, headers: headers
          
          expect(response).to have_http_status(:ok)
        end

        it "returns 401 if not authenticated" do
          get api_v1_conversations_path
          expect(response).to have_http_status(:unauthorized)
        end
    context "user has no buyer or seller profiles" do
          let(:mock_user) { create(:user) }
          let(:mock_token) do 
            Doorkeeper::AccessToken.create!(
              resource_owner_id: mock_user.id, 
              application_id: application.id,
              scopes: "public"
            ).token 
          end
          let(:mock_headers) { {"Authorization" => "Bearer #{mock_token}"} }
          it "returns empty list without crashing" do
            allow_any_instance_of(User).to receive(:buyer).and_return(nil)
            allow_any_instance_of(User).to receive(:seller).and_return(nil)

            get api_v1_conversations_path, headers: mock_headers
            
            expect(response).to have_http_status(:ok)
            json = JSON.parse(response.body)
            expect(json).to be_empty
          end
    end
  
  end

  describe "GET /api/v1/conversations/:id" do
    it "returns the specific conversation with nested associations" do
      create(:message, conversation: conv_as_seller, body: "Hello World")
      
      get api_v1_conversation_path(conv_as_seller), headers: headers
      
      expect(response).to have_http_status(:ok)

    end
  end
end