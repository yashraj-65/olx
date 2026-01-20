require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:buyer) { user.buyer }
  let!(:seller) { user.seller }
  
  let!(:other_user) { create(:user) }
  let!(:other_seller) {  other_user.seller }
  let!(:item) { create(:item, seller: other_seller) }

  before { sign_in user }

  describe "POST #create" do
    it "finds an existing conversation instead of creating a new one" do
      existing = Conversation.create!(buyer_id: buyer.id, seller_id: other_seller.id, item_id: item.id)
      
      expect {
        post :create, params: { seller_id: other_seller.id, item_id: item.id }
      }.not_to change(Conversation, :count)
      
      expect(response).to redirect_to(conversation_path(existing))
    end
  end

  describe "GET #index" do
    it "returns conversations where the user is either the buyer or the seller" do
      conv_as_buyer = create(:conversation, buyer_id: buyer.id, seller_id: other_seller.id, item: item)
    random_buyer = create(:buyer) 
    item_i_own = create(:item, seller: seller)
    conv_as_seller = create(:conversation, seller_id: seller.id, buyer_id: random_buyer.id, item: item_i_own)
      
      get :index
      expect(assigns(:conversations).to_a).to include(conv_as_buyer, conv_as_seller)
    end
  end

  describe "GET #show" do
    it "shows conversation" do
      my_conversation = create(:conversation, buyer_id: buyer.id, item: item)

      get :show, params: { id: my_conversation.id }
      
      expect(response).to have_http_status(:success)
      expect(assigns(:conversation)).to eq(my_conversation)
    end

    it "redirects when unauthorized conversation" do
      stranger_conv = create(:conversation) 

      get :show, params: { id: stranger_conv.id }
      
      expect(response).to redirect_to(conversations_path)
      expect(flash[:alert]).to eq("You do not have access to that conversation.")
    end
  end
end