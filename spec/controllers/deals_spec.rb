require 'rails_helper'

RSpec.describe DealsController, type: :controller do
  let(:user) { create(:user) }
  let(:buyer) { user.buyer}
  let(:seller) { user.seller }

  before do
    sign_in user 
  end

  describe "GET #index" do
    it "filters deals correctly for the current user" do
      convo = create(:conversation, buyer_profile: buyer, seller_profile: seller)
      my_deal = create(:deal, conversation: convo)
      
      other_deal = create(:deal)

      get :index

      expect(assigns(:all_deals)).to include(my_deal)
      expect(assigns(:all_deals)).not_to include(other_deal)
      expect(response).to render_template(:index)
    end
  end

  describe "PATCH #update" do
    let(:mock_deal) { instance_double(Deal, id: 5) }
    let(:mock_convo) { instance_double(Conversation, seller_id: user.seller.id, buyer_id: 20) }

    before do
      allow(Deal).to receive(:find).with("5").and_return(mock_deal)
      allow(mock_deal).to receive(:conversation).and_return(mock_convo)
      allow(mock_convo).to receive(:seller_id).and_return(user.seller.id)
      allow(mock_convo).to receive(:buyer_id).and_return(20)
    end

    context "when user is the seller" do
      it "updates seller_marked_done" do
        allow(user).to receive(:seller).and_return(double(id: 10))
        allow(user).to receive(:buyer).and_return(nil)

        expect(mock_deal).to receive(:update).with(seller_marked_done: true)

        patch :update, params: { id: 5 }
      
        expect(response).to redirect_to(deals_path)
      end
    end
    context "when user is the buyer" do
      it "updates buyer_marked_done" do
        allow(mock_convo).to receive(:seller_id).and_return(999) 
        allow(mock_convo).to receive(:buyer_id).and_return(user.buyer.id)
        allow(user).to receive(:buyer).and_return(double(id: 20))
        allow(user).to receive(:seller).and_return(nil)

        expect(mock_deal).to receive(:update).with(buyer_marked_done: true)

        patch :update, params: { id: 5 }
      
        expect(response).to redirect_to(deals_path)
      end
    end
    context "when user is not authorized" do
      it "sets an alert flash and redirects" do
  
        allow(mock_convo).to receive(:seller_id).and_return(999)
        allow(mock_convo).to receive(:buyer_id).and_return(888)

        allow(user).to receive(:seller).and_return(user.seller)
        allow(user).to receive(:buyer).and_return(user.buyer)

        expect(mock_deal).not_to receive(:update)

        patch :update, params: { id: 5 }
      
        expect(flash[:alert]).to eq("You are not authorized to confirm this deal.")
        expect(response).to redirect_to(deals_path)
      end
    end

  end

  describe "DELETE #destroy" do
    let(:mock_deal) { instance_double(Deal, id: 1) }

    it "deletes the deal and redirects" do
      allow(Deal).to receive(:find).with("1").and_return(mock_deal)
      expect(mock_deal).to receive(:destroy)

      delete :destroy, params: { id: 1 }

      expect(response).to redirect_to(deals_path)
      expect(flash[:notice]).to match(/successfully deleted/)
    end

  end
 describe "POST #create" do
    let(:mock_item) { instance_double(Item) }
    let(:mock_convo) { instance_double(Conversation, id: 22, item: mock_item) }
    let(:mock_deal) { instance_double(Deal) }
    let(:deal_params) { { agreed_price: "100" } }
    let(:deals_association) { double("deals_association") }

    before do

      allow(Conversation).to receive(:find).with("22").and_return(mock_convo)
      allow(mock_convo).to receive(:to_model).and_return(mock_convo)
      allow(mock_convo).to receive(:persisted?).and_return(true)
      allow(mock_convo).to receive(:model_name).and_return(Conversation.model_name)
      allow(mock_item).to receive(:deals).and_return(deals_association)
      allow(deals_association).to receive(:build).with(anything).and_return(mock_deal)

      allow(mock_deal).to receive(:conversation=)
      allow(mock_deal).to receive(:proposer=)
      allow(mock_deal).to receive(:status=)
      allow(mock_deal).to receive(:buyer_marked_done=)
      allow(mock_deal).to receive(:seller_marked_done=)
      
      allow(mock_convo).to receive(:item).and_return(mock_item)
    end

    context "when current_user is the buyer" do
      it "creates a deal and marks buyer_marked_done as true" do
        allow(mock_convo).to receive(:buyer_profile).and_return(user.buyer)
        
        expect(mock_deal).to receive(:buyer_marked_done=).with(true)
        expect(mock_deal).to receive(:save).and_return(true)

        post :create, params: { conversation_id: 22, deal: deal_params }

        expect(response).to redirect_to(conversation_path(mock_convo))
        expect(flash[:notice]).to eq("Deal has been proposed!")
      end
    end

    context "when saving fails" do
      it "redirects with an alert" do
        allow(mock_convo).to receive(:buyer_profile).and_return(nil)
        expect(mock_deal).to receive(:save).and_return(false)

        post :create, params: { conversation_id: 22, deal: deal_params }

        expect(response).to redirect_to(conversation_path(mock_convo))
        expect(flash[:alert]).to eq("deal failed")
      end
    end
  end
end