require 'rails_helper'

RSpec.describe "Api::V1::Messages", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
let(:seller_profile) { user.reload.seller }
  let(:buyer_profile) { other_user.reload.buyer }
  let(:item) { create(:item, seller: seller_profile) }
  
  
  let!(:conversation) do 
    create(:conversation, 
      item: item, 
      seller_profile: seller_profile, 
      buyer_profile: buyer_profile
    ) 
  end
  let!(:message) { create(:message, conversation: conversation, user: other_user) }

  let(:application) { create(:oauth_application) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id, application_id: application.id, scopes: "public").token }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /api/v1/conversations/:conversation_id/messages" do
    it "returns messages for an authorized participant" do
        puts "USER ID: #{user.id}"
  puts "USER SELLER ID: #{user.seller&.id}"
  puts "CONVERSATION SELLER ID: #{conversation.seller_id}"
      get api_v1_conversation_messages_path(conversation), headers: headers
      expect(response).to have_http_status(:ok)

    end


  end

  describe "GET /api/v1/conversations/:conversation_id/messages/:id" do
    it "returns a specific message" do
      get api_v1_conversation_message_path(conversation, message), headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST api/v1/conversations/:conversation_id/messages" do
    let(:valid_params) { { message: { body: "Hello, I am interested!" } } }

    it "creates a message and links it to the current_user" do
      
        post api_v1_conversation_messages_path(conversation), params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
      
    end

    it "returns 422 " do
      post api_v1_conversation_messages_path(conversation), params: { message: { body: "" } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end