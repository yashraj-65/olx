require 'rails_helper'

RSpec.describe BuyersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:seller) { user.seller}
  let!(:buyer) { user.buyer }
  
  let!(:other_user) { create(:user) }
  let!(:other_seller) { other_user.seller }
  let!(:other_buyer) {  other_user.buyer }

  before { sign_in user }

  describe "GET #show" do
    context "when viewing own buyer profile" do
      it "loads seller reviews, active listings, and personal history" do
        review = create(:review, seller: seller, rating: 5)
        active_item = create(:item, seller: seller, status: :available)
        sold_item = create(:item, seller: seller, status: :sold)
        
        user.reload

        get :show, params: { id: buyer.id }

        expect(response).to have_http_status(:success)
        expect(assigns(:buyer)).to eq(buyer) 
        expect(assigns(:user)).to eq(user)
        expect(assigns(:active_listings)).to include(active_item)
        expect(assigns(:sold_items)).to include(sold_item)
      end
    end

    context "when viewing someone else's buyer profile" do
      it "hides sold and bought items for privacy" do
        get :show, params: { id: other_buyer.id }
        expect(assigns(:sold_items)).to eq([])
        expect(assigns(:bought_items)).to eq([])
      end
    end

    context "when user does not have a buyer profile" do
        it "assigns an empty array to bought_items" do
            solo_user = create(:user)
            solo_seller = create(:seller, userable: solo_user)
            
            sign_in solo_user
            get :show, params: { id: other_buyer.id }
            
            expect(assigns(:bought_items)).to eq([])
        end
        end
        it "hides history when viewing someone else" do
            get :show, params: { id: other_buyer.id }

            expect(assigns(:user)).to eq(other_user)
            expect(assigns(:sold_items)).to eq([])
            expect(assigns(:bought_items)).to eq([])
        end
it "handles missing buyer profile via stubbing" do
      allow_any_instance_of(User).to receive(:buyer).and_return(nil)
      get :show, params: { id: buyer.id }
      expect(assigns(:bought_items)).to eq([])
    end

    it "handles missing seller profile via stubbing" do
      allow_any_instance_of(User).to receive(:seller).and_return(nil)     
      get :show, params: { id: buyer.id }     
      expect(assigns(:reviews)).to eq([])
      expect(assigns(:active_listings)).to be_empty
    end
  end
end