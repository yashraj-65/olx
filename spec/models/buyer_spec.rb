require 'rails_helper'

RSpec.describe Buyer, type: :model do

    subject{
        build(:buyer)
    }

    describe "associations" do
        it "belongs to userable" do
            assoc = described_class.reflect_on_association(:userable)
            expect(assoc.macro).to eq (:belongs_to)
        end
        it "has many deals" do
            assoc = described_class.reflect_on_association(:deals)
            expect(assoc.macro).to eq(:has_many)
            expect(assoc.options[:through]).to eq(:conversations)
        end
        it "has many likes" do
            assoc = described_class.reflect_on_association(:likes)
            expect(assoc.macro).to eq(:has_many)
            expect(assoc.options[:dependent]).to eq(:destroy)
        end

        it "has many reviews with foreign_key reviewer_id" do
        association = described_class.reflect_on_association(:reviews)
        expect(association.macro).to eq(:has_many)
        expect(association.options[:foreign_key]).to eq(:reviewer_id)
        end
    end
    describe "ransackable attributes" do 
        it "allows ransackable attributes" do
            expected_attributes =   ["created_at", "id", "purchase_count", "total_spent", "updated_at", "userable_id", "userable_type"]
            expect(Buyer.ransackable_attributes).to match_array(expected_attributes)
        end
         it "allows ransackable associations" do
            expected_associations =      ["userable", "items", "likes","reviews"]
            expect(Buyer.ransackable_associations).to match_array(expected_associations)
        end
    end
end