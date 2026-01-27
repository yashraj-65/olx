# spec/services/items/create_service_spec.rb
require 'rails_helper'

RSpec.describe Items::CreateService do
  let(:user) { create(:user) }
  let(:seller) { user.seller || create(:seller, userable: user) }
  
  describe "#call" do
    context "with valid parameters" do
      let(:item_params) { { title: "New Item", price: 100, desc: "A great item" } }
      subject(:service) { described_class.new(user, item_params) }

      it "creates a new item" do
        expect { service.call }.to change(Item, :count).by(1)
      end

      it "associates the item with the user's seller profile" do
        result = service.call
        expect(result[:item].seller).to eq(user.seller)
      end

      it "returns a success hash" do
        result = service.call
        expect(result[:success]).to be true
        expect(result[:item]).to be_persisted
      end
    end

    context "with invalid parameters" do
      let(:item_params) { { title: "", price: 100 } }
      subject(:service) { described_class.new(user, item_params) }

      it "does not create a new item" do
        expect { service.call }.not_to change(Item, :count)
      end

      it "returns a failure hash with errors" do
        result = service.call
        expect(result[:success]).to be false
        expect(result[:errors]).to be_present
        expect(result[:item]).not_to be_persisted
      end
    end

    context "when user has no seller profile" do
      let(:user_without_seller) { create(:user) }
      let(:item_params) { { title: "New Item" } }
      

    end
  end
end