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
end