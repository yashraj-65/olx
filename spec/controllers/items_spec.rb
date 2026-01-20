require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:seller) { user.seller || create(:seller, userable: user) }
  let(:other_user) { create(:user) }
  let(:category) { create(:category) }
  let(:valid_attributes) do
    {
      title: "MacBook Pro",
      price: 1500,
      desc: "Brand new laptop with M3 chip",
      category_ids: [category.id]
    }
  end

  before { sign_in user }

  describe "GET index" do
    it "returns all items and filters by category" do
      item_in_cat = create(:item, categories: [category])
      other_item = create(:item)
      get :index, params: { category: category.id }
      expect(assigns(:items)).to include(item_in_cat)
      expect(assigns(:items)).not_to include(other_item)
    end

    it "searches items by query" do
      searchable_item = create(:item, title: "Vintage Camera")
      get :index, params: { query: "Camera" }
      expect(assigns(:items)).to include(searchable_item)
    end

    it "shows an item" do
      item = create(:item)
      get :show, params: { id: item.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:item)).to eq(item)
    end
  end

  describe "POST #create" do
    context "with real database records" do
      it "creates a new Item" do
        expect {
          post :create, params: { item: valid_attributes }
        }.to change(Item, :count).by(1)
      end

      it "redirects to the created item" do
        post :create, params: { item: valid_attributes }
        expect(response).to redirect_to(Item.last)
        expect(flash[:notice]).to eq('Item Created Successfully')
      end
    end
  end

  describe "GET #new" do
    it "assigns a new item and loads all categories" do
      category1 = create(:category)
      category2 = create(:category)
      get :new
      expect(assigns(:item)).to be_a_new(Item)
      expect(assigns(:categories)).to include(category1, category2)
      expect(response).to render_template(:new)
    end
  end

  describe "Mocked Actions (Create, Update, Destroy, Edit)" do
    let(:mock_seller) { instance_double(Seller) }
    let(:mock_item) { instance_double(Item, id: 10) }
    let(:valid_params) do
      { title: "New Product", price: 500, desc: "This is a long description." }
    end

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:seller).and_return(mock_seller)
      allow(mock_seller).to receive(:items).and_return(Item)
      
      allow(mock_item).to receive(:to_model).and_return(mock_item)
      allow(mock_item).to receive(:persisted?).and_return(true)
      allow(mock_item).to receive(:model_name).and_return(Item.model_name)
    end

    it "successfully redirects after saving" do
      allow(Item).to receive(:build).and_return(mock_item)
      allow(mock_item).to receive(:save).and_return(true)

      post :create, params: { item: valid_params }
      expect(response).to redirect_to(item_path(mock_item))
    end

    it "saving fails" do
      allow(Item).to receive(:build).and_return(mock_item)
      allow(mock_item).to receive(:save).and_return(false)
      allow(Category).to receive(:all).and_return([])

      post :create, params: { item: valid_params }
      expect(response).to render_template(:new)
    end

    it "successfully deletes the item" do
      allow(Item).to receive(:find).with("11").and_return(mock_item)
      allow(mock_item).to receive(:seller).and_return(mock_seller)
      allow(mock_item).to receive(:destroy).and_return(true)

      delete :destroy, params: { id: 11 }
      expect(response).to redirect_to(items_path)
      expect(flash[:notice]).to eq("Item was successfully deleted.")
    end

    it "failed to delete" do
      allow(Item).to receive(:find).with("11").and_return(mock_item)
      allow(mock_item).to receive(:seller).and_return(mock_seller)
      allow(mock_item).to receive(:destroy).and_return(false)

      delete :destroy, params: { id: 11 }
      expect(response).to redirect_to(items_path)
      expect(flash[:alert]).to eq("Failed to delete item.")
    end

    it "edits the item and loads categories" do
      allow(Item).to receive(:find).with("12").and_return(mock_item)
      allow(Category).to receive(:all).and_return([])
      
      get :edit, params: { id: 12 }
      
      expect(assigns(:item)).to eq(mock_item)
      expect(assigns(:categories)).to eq([])
      expect(response).to render_template(:edit)
    end

    describe "PATCH #update" do
      before do
        allow(Item).to receive(:find).with("10").and_return(mock_item)
      end

      context "with valid parameters" do
        it "updates and redirects" do
          expect(mock_item).to receive(:update).and_return(true)
          patch :update, params: { id: 10, item: valid_params }
          expect(response).to redirect_to(item_path(mock_item))
        end
      end

      context "with invalid parameters" do
        it "renders edit with unprocessable_entity status" do
          allow(mock_item).to receive(:update).and_return(false)
          allow(Category).to receive(:all).and_return([])
          patch :update, params: { id: 10, item: { title: "" } }
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when unauthorized" do
      it "redirects to index with an alert when user is not the owner" do
        other_seller_mock = instance_double(Seller)
        allow(Item).to receive(:find).with("11").and_return(mock_item)
        allow(mock_item).to receive(:seller).and_return(other_seller_mock)

        delete :destroy, params: { id: 11 }

        expect(response).to redirect_to(items_path)
        expect(flash[:alert]).to eq("You are not authorized to delete this item.")
      end
    end
  end
end