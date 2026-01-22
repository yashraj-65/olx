require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:seller) { user.seller || create(:seller, userable: user) }
  let(:item) { create(:item, seller: seller) }
  let(:category) { create(:category) }

  before { sign_in user }

  describe "GET #index" do
    it "calls IndexService and assigns items" do
      mock_items = double('Items')
      # Test the service initialization and call
      service_instance = instance_double(Items::IndexService)
      expect(Items::IndexService).to receive(:new).with(anything).and_return(service_instance)
      expect(service_instance).to receive(:call).and_return({ items: mock_items })

      get :index
      expect(assigns(:items)).to eq(mock_items)
    end
  end

  describe "GET #new" do
    it "assigns new item and all categories" do
      create_list(:category, 2)
      get :new
      expect(assigns(:item)).to be_a_new(Item)
      expect(assigns(:categories).count).to eq(Category.count)
    end
  end

  describe "GET #show" do
    it "finds the item" do
      get :show, params: { id: item.id }
      expect(assigns(:item)).to eq(item)
    end
  end

  describe "POST #create" do
    let(:valid_params) { { title: "Test Item" } }

    it "redirects on success" do
      service = instance_double(Items::CreateService)
      expect(Items::CreateService).to receive(:new).and_return(service)
      expect(service).to receive(:call).and_return({ success: true, item: item })

      post :create, params: { item: valid_params }
      expect(response).to redirect_to(item_path(item))
      expect(flash[:notice]).to eq('Item Created Successfully')
    end

it "renders new on failure (sad path coverage)" do
  create(:category) # Add this line to ensure Category.all is not empty
  service = instance_double(Items::CreateService)
  expect(Items::CreateService).to receive(:new).and_return(service)
  expect(service).to receive(:call).and_return({ success: false, item: Item.new })

  post :create, params: { item: { title: "" } }
  expect(response).to render_template(:new)
  expect(response).to have_http_status(:unprocessable_content) # Updated to fix the warning
  expect(assigns(:categories)).to be_present
end
  end

  describe "GET #edit" do
it "assigns the item and categories for the current seller" do
  create(:category) # Add this line
  get :edit, params: { id: item.id }
  expect(assigns(:item)).to eq(item)
  expect(assigns(:categories)).to be_present
end
  end

  describe "PATCH #update" do
    it "redirects on success" do
      service = instance_double(Items::UpdateService)
      expect(Items::UpdateService).to receive(:new).and_return(service)
      expect(service).to receive(:call).and_return({ success: true, item: item })

      patch :update, params: { id: item.id, item: { title: "New" } }
      expect(response).to redirect_to(item_path(item))
    end

    it "renders edit on failure" do
      service = instance_double(Items::UpdateService)
      expect(Items::UpdateService).to receive(:new).and_return(service)
      expect(service).to receive(:call).and_return({ success: false, item: item })

      patch :update, params: { id: item.id, item: { title: "" } }
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    context "as the owner" do
      it "deletes and redirects with success message" do
        service = instance_double(Items::DestroyService)
        expect(Items::DestroyService).to receive(:new).and_return(service)
        expect(service).to receive(:call).and_return({ success: true })

        delete :destroy, params: { id: item.id }
        expect(response).to redirect_to(items_path)
        expect(flash[:notice]).to eq("Item was successfully deleted.")
      end

      it "redirects with alert on service failure" do
        service = instance_double(Items::DestroyService)
        expect(Items::DestroyService).to receive(:new).and_return(service)
        expect(service).to receive(:call).and_return({ success: false })

        delete :destroy, params: { id: item.id }
        expect(flash[:alert]).to eq("Failed to delete item.")
      end
    end

    context "as a non-owner (ensure_owner coverage)" do
      let(:other_user) { create(:user) }
      let(:other_item) { create(:item) } # Belongs to a different seller

      it "prevents deletion" do
        delete :destroy, params: { id: other_item.id }
        expect(response).to redirect_to(items_path)
        expect(flash[:alert]).to eq("You are not authorized to delete this item.")
      end
    end
  end
end