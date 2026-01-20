require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:buyer) { user.buyer }
  let(:item) { create(:item) }
  let(:review) { create(:review) }

  before do
    sign_in user
    request.env["HTTP_REFERER"] = root_path
  end

  describe "POST create item" do
    context "when the item is not yet liked" do
      it "creates a new like for the item" do
        expect {
          post :create, params: { item_id: item.id }
        }.to change(Like, :count).by(1)

        expect(Like.last.likeable).to eq(item)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when the item is already liked" do
      it "does not create a duplicate like" do
        create(:like, buyer: buyer, likeable: item)

        expect {
          post :create, params: { item_id: item.id }
        }.not_to change(Like, :count)

        expect(response).to redirect_to(root_path)
      end
    end
    context "when the like fails to save" do
    it "redirects back with a notice even on failure" do
      item = create(:item)
      allow_any_instance_of(Like).to receive(:save).and_return(false)
      post :create, params: { item_id: item.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("likes!")
    end
  end
  end

  describe "POST #like_review" do
    it "creates a like for a review" do
      expect {
        post :like_review, params: { id: review.id }
      }.to change(Like, :count).by(1)

      expect(Like.last.likeable).to eq(review)
    end
    it "does not create a duplicate like" do
        create(:like, buyer: buyer, likeable: review)
        expect {
          post :like_review, params: { id: review.id }
        }.not_to change(Like, :count)

        expect(response).to redirect_to(root_path)
    end
    context "when the like fails to save" do
        it "redirects back with a notice even on failure"    do
            review = create(:review)
            allow_any_instance_of(Like).to receive(:save).and_return(false)
            post :like_review, params: { id: review.id }
            expect(response).to redirect_to(root_path)
        end
    end
  end

  describe "DELETE #destroy" do
    let!(:like) { create(:like, buyer: buyer, likeable: item) }

    it "removes the like" do
      expect {
        delete :destroy, params: { id: like.id }
      }.to change(Like, :count).by(-1)
      
      expect(flash[:notice]).to eq("unliked!")
    end
  end

  describe "GET #index" do
    it "only shows liked items, not liked reviews" do
      item_like = create(:like, buyer: buyer, likeable: item)
      review_like = create(:like, buyer: buyer, likeable: review)

      get :index

      expect(assigns(:liked_items)).to include(item)
      expect(assigns(:liked_items)).not_to include(review)
    end
  end
end