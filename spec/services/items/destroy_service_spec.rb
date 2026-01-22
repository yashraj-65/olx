# spec/services/items/destroy_service_spec.rb
require 'rails_helper'

RSpec.describe Items::DestroyService do
  let(:user) { create(:user) }
  let(:seller) { user.seller || create(:seller, userable: user) }
  let!(:item) { create(:item, seller: seller) }
  let(:item_id) { item.id }
  
  subject(:service) { described_class.new(user, item_id) }

  describe "#call" do
    context "when deletion is successful" do
      it "removes the item from the database" do
        expect { service.call }.to change(Item, :count).by(-1)
      end

      it "returns a success hash" do
        result = service.call
        expect(result[:success]).to be true
        expect(result[:item].id).to eq(item_id)
      end
    end

    context "when the item does not belong to the user" do
      let(:other_item) { create(:item) }
      let(:item_id) { other_item.id }

      it "raises ActiveRecord::RecordNotFound" do
        # This confirms that the user cannot destroy items they don't own
        expect { service.call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when deletion fails (database restriction)" do
      before do
        # Simulate a case where destroy returns false (e.g., a before_destroy callback)
        allow_any_instance_of(Item).to receive(:destroy).and_return(false)
      end

      it "returns success false" do
        result = service.call
        expect(result[:success]).to be false
      end
    end
  end
end