require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:buyer) { user.buyer } 
  let(:seller_user) { create(:user) }
  let(:seller) { seller_user.seller }
  
  let(:item) { create(:item, seller: seller) }
  let(:deal) { create(:deal, item: item) }

  before do
    sign_in user
  end

  describe "POST #create_review" do
    let(:valid_params) { { comment: "Great!", rating: 5 } }

    it "creates a review and redirects to the item path" do
      expect {
        post :create_review, params: { deal_id: deal.id, review: valid_params }
      }.to change(Review, :count).by(1)

      last_review = Review.last
      expect(last_review.reviewer).to eq(buyer)
      expect(last_review.seller).to eq(seller)
      expect(response).to redirect_to(item_path(item))
    end

    it "fails with invalid rating and redirects with alert" do
      post :create_review, params: { deal_id: deal.id, review: { rating: 6 } } # Invalid rating
      
      expect(flash[:alert]).to eq("deal failed!!!!")
      expect(response).to redirect_to(item_path(item))
    end
  end

  describe "DELETE #destroy" do
    let!(:review) { create(:review, reviewer: buyer, deal: deal, seller: seller) }

    context "when the current user is the owner of the review" do
      it "deletes the review" do
        expect {
          delete :destroy, params: { id: review.id }
        }.to change(Review, :count).by(-1)
        
        expect(flash[:notice]).to eq("Review deleted.")
      end
    end

    context "when a different user tries to delete the review" do
      it "does not delete the review and shows an alert" do
        other_user = create(:user)
        sign_in other_user 

        expect {
          delete :destroy, params: { id: review.id }
        }.not_to change(Review, :count)

        expect(flash[:alert]).to eq("Not authorized.")
      end
    end
  end
end