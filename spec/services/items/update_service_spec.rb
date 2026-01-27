require 'rails_helper'

RSpec.describe Items::UpdateService do
  let(:user) { create(:user) }
  let(:seller) { user.seller || create(:seller, userable: user) }
  let(:item) { create(:item, seller: seller, title: "Old Title") }
  let(:item_id) { item.id }
  
  subject(:service) { described_class.new(user, item_id, item_params) }

  describe "#call" do
    context "when update is successful" do
      let(:item_params) { { title: "New Shiny Title" } }

      it "updates the item attributes" do
        result = service.call
        expect(result[:success]).to be true
        expect(result[:item].title).to eq("New Shiny Title")
        expect(item.reload.title).to eq("New Shiny Title")
      end
    end

    context "when update fails" do
      let(:item_params) { { title: "" } }

      it "returns success false and include errors" do
        result = service.call
        expect(result[:success]).to be false
        expect(result[:item].errors).not_to be_empty
        expect(result[:errors]).to be_present
      end

      it "does not update the record in the database" do
        service.call
        expect(item.reload.title).to eq("Old Title")
      end
    end

    context "when item does not belong to the user's seller" do
      let(:other_item) { create(:item) }
      let(:item_id) { other_item.id }
      let(:item_params) { { title: "Hacker Title" } }

      it "raises an ActiveRecord::RecordNotFound error" do
        expect { service.call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end