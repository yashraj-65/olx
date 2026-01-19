require 'rails_helper'

RSpec.describe Item, type: :model do
    subject{
        build(:item)
    }
    describe "filters and scopes" do
        let!(:electronics) {Category.create!(kind: :electronics)}
        let!(:furniture) {Category.create!(kind: :furniture)}
        let(:item_in_query) {create(:item,title: "vintage")}
        let!(:item_in_electronics) { create(:item, categories: [electronics],status: :available)}
        let!(:item_in_furniture) { create(:item, categories: [furniture],status: :available)}
        let!(:sold_item) { create(:item, categories: [electronics],status: :sold)}
        it "item belonging to a category" do
            results = Item.filter_by_category(electronics.id)
            expect(results).to include(item_in_electronics)
            expect(results).not_to include(item_in_furniture)
        end
        it "item belonging to a category and item not sold" do
            results = Item.filter_by_category(electronics.id)
            expect(results).not_to include(sold_item)
        end
        it "search by query" do

            results = Item.search_by_query("vintage")
            expect(results).to include(item_in_query)
        end
    end
    describe "validations" do
        it "is valid with a attributes" do
            expect(subject).to be_valid
        end
        it "is valid with a title" do
            subject.title = nil
            expect(subject).not_to be_valid
        end
        it "is valid with a prize" do
            subject.price=nil
            expect(subject).not_to be_valid
        end
        it "is valid with a desc" do
            subject.desc=nil
            expect(subject).not_to be_valid
        end
    end

    describe"callback" do
        context "set status" do
            it "set default status" do
                expect(subject.status).to  be_nil
                
                subject.save

                expect(subject.available?).to be true
            end
        end
    
    end

    describe "associations" do
        it "has many deals" do
            assoc = described_class.reflect_on_association(:deals)
            expect(assoc.macro).to eq(:has_many)
        end
        it "has many likes" do
              assoc = described_class.reflect_on_association(:likes)
              expect(assoc.macro).to eq (:has_many)
              expect(assoc.options[:as]).to eq :likeable
              expect(assoc.options[:dependent]).to eq(:destroy)
        end
        it "has many conversations" do
            assoc = described_class.reflect_on_association(:conversations)
            expect(assoc.macro).to eq(:has_many)
            expect(assoc.options[:dependent]).to eq(:destroy)
        end
    end

    describe "ransackable attributes" do 
        it "allows ransackable attributes" do
            expected_attributes =   ["id", "title", "price", "status", "condition", "desc", "warranty", "color", "created_at"]
            expect(Item.ransackable_attributes).to match_array(expected_attributes)
        end
         it "allows ransackable associations" do
            expected_associations = ["seller", "deals","categories"]   
            expect(Item.ransackable_associations).to match_array(expected_associations)
        end
    end
end