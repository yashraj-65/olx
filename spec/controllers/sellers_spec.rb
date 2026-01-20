require 'rails_helper'

RSpec.describe SellersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:seller) { user.seller } 
  let(:other_seller) { other_user.seller }

  before do
    sign_in user
  end

  describe "GET #show" do
    context "when viewing my own profile" do
      it "loads sold and bought items" do
        get :show, params: { id: seller.id }

        expect(response).to have_http_status(:success)
        expect(assigns(:seller)).to eq(seller)
        expect(assigns(:user)).to eq(user)
        expect(assigns(:sold_items)).to eq(user.sold_items)
        expect(assigns(:bought_items)).to eq(user.bought_items)
        expect(response).to render_template(:show)
      end
    end

    context "when viewing someone else profile" do
      it "hides sold and bought items" do
        get :show, params: { id: other_seller.id }

        expect(response).to have_http_status(:success)
        expect(assigns(:seller)).to eq(other_seller)
        expect(assigns(:sold_items)).to eq([])
        expect(assigns(:bought_items)).to eq([])
      end
    end
    context "when the user dont have  buyer profile" do
        it "assigns an empty array to bought_items" do
            user.buyer.destroy 
            user.reload 

            get :show, params: { id: seller.id }
            expect(assigns(:bought_items)).to eq([])
        end
    end

    context "calculating ratings and " do
      it "calculates the average rating " do
        reviewer_user = create(:user)
        reviewer_buyer = reviewer_user.buyer
        my_deal = create(:deal, seller: seller,buyer: reviewer_buyer)
        create(:review, seller: seller, deal: my_deal, reviewer: reviewer_buyer, rating: 5)
        create(:review, seller: seller, deal: my_deal, reviewer: reviewer_buyer, rating: 3)

        get :show, params: { id: seller.id }
        expect(assigns(:average_rating)).to eq(4.0)
      end

      it "only shows active listings (available or nil status)" do
        active_item = create(:item, seller: seller, status: :available)
        sold_item = create(:item, seller: seller, status: 2) 

        get :show, params: { id: seller.id }

        expect(assigns(:active_listings)).to include(active_item)
        expect(assigns(:active_listings)).not_to include(sold_item)
      end
    end
  end
end