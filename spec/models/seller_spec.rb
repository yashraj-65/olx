require 'rails_helper'

RSpec.describe Seller, type: :model do
        subject{
            build(:seller)
        }

        describe "associations" do
            it "belongs to polymorphic userable" do
                assoc = described_class.reflect_on_association(:userable)
                expect(assoc.macro).to eq (:belongs_to)
            end
            it "has many deals" do
                assoc = described_class.reflect_on_association(:deals)
                expect(assoc.macro).to eq (:has_many)
                expect(assoc.options[:through]).to eq(:conversations)
            end

            it "has many reviews" do
                assoc = described_class.reflect_on_association(:reviews)
                expect(assoc.macro).to eq (:has_many)
            end
           it "has many items" do
                assoc = described_class.reflect_on_association(:items)
                expect(assoc.macro).to eq (:has_many)
            end
            it "has many conversations" do
                assoc = described_class.reflect_on_association(:conversations)
                expect(assoc.macro).to eq (:has_many)
            end
        end

    describe "ransackable attributes" do 
            it "allows ransackable attributes" do
                expected_attributes = ["id", "avg_rating","contact_number", "created_at", "updated_at", "userable_id", "userable_type"]
                expect(Seller.ransackable_attributes).to match_array(expected_attributes)
            end
            it "allows ransackable associations" do
                expected_associations =  ["userable", "items","reviews","deals"]
                expect(Seller   .ransackable_associations).to match_array(expected_associations)
            end
    end
end