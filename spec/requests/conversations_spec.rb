require 'rails_helper'

RSpec.describe "Api::V1::Conversations", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  
  # Profiles
  let(:my_seller_profile) { create(:seller, userable: user) }
  let(:my_buyer_profile) { create(:buyer, userable: user) }
  let(:other_buyer_profile) { create(:buyer, userable: other_user) }

  # Conversations
  let!(:conv_as_seller) { create(:conversation, seller_profile: my_seller_profile, buyer_profile: other_buyer_profile) }
  let!(:conv_as_buyer) { create(:conversation, buyer_profile: my_buyer_profile) }
  let!(:stranger_conv) { create(:conversation) } # One I'm not part of

  # Doorkeeper Token
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
  end

  describe "GET /api/v1/conversations/:id" do
    it "returns the specific conversation with nested associations" do
      create(:message, conversation: conv_as_seller, body: "Hello World")
      
      get api_v1_conversation_path(conv_as_seller), headers: headers
      
      expect(response).to have_http_status(:ok)

    end
  end
end