require 'rails_helper'

RSpec.describe Deal, type: :model do
    subject{
        build(:deal)
    }

    describe "associations" do
        it "belongs to conversation" do
            assoc = described_class.reflect_on_association(:conversation)
            expect(assoc.macro).to eq(:belongs_to)

        end

        it "belongs to item" do
            assoc = described_class.reflect_on_association(:item)
            expect(assoc.macro).to eq(:belongs_to)
        end
        it "has one seller" do
            assoc = described_class.reflect_on_association(:seller)
            expect(assoc.macro).to eq(:has_one)
            expect(assoc.options[:through]).to eq(:conversation)
        end

        it "belongs to proposer" do
            assoc = described_class.reflect_on_association(:proposer)
            expect(assoc.macro).to eq(:belongs_to)
            expect(assoc.options[:foreign_key]).to eq(:proposer_id)
            expect(assoc.options[:class_name]).to eq("User")
        end
        it "has many reviews" do
            assoc = described_class.reflect_on_association(:reviews)
            expect(assoc.macro).to eq(:has_many)
        end
    end
    describe "call backs" do
       
        let!(:item) { create(:item, status: :available)}
         let!(:conversation) { create(:conversation) }
        let!(:deal) {create(:deal,item: item,buyer_marked_done: false,seller_marked_done: false)}
        context "both parties agree to deal" do
            it "marked item as sold" do
                expect(item.available?).to be true

                deal.update(buyer_marked_done: true, seller_marked_done: true)

                expect(item.reload.status).to eq("sold")

            end
        end

        context "when only one party confirms" do
            it "does not mark the item as sold" do
                deal.update(buyer_marked_done: true, seller_marked_done: false)    
                expect(item.reload.status).not_to eq("sold")
            end
        end

    end
end