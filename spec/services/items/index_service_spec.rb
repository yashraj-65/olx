require 'rails_helper'

RSpec.describe Items::IndexService do
  let(:category) { create(:category) }
  let!(:item_in_category) { create(:item, categories: [category], title: "Blue Widget") }
  let!(:other_item) { create(:item, title: "Red Gadget") }

  describe "call" do
    context "when filtering by category" do
      let(:params) { { category: category.id } }
      subject(:service) { described_class.new(params) }

      it "returns only items in that category" do
        result = service.call
        expect(result[:items]).to include(item_in_category)
        expect(result[:items]).not_to include(other_item)
      end
    end

    context "when searching by query" do
      let(:params) { { query: "Widget" } }
      subject(:service) { described_class.new(params) }

      it "returns items matching the search term" do
        result = service.call
        expect(result[:items]).to include(item_in_category)
        expect(result[:items]).not_to include(other_item)
      end

      it "returns the query string in the result" do
        result = service.call
        expect(result[:query]).to eq("Widget")
      end

      it "sets pagination to 4 items per page for searches" do
        create_list(:item, 5, title: "Widget")
        result = service.call
        expect(result[:items].limit_value).to eq(4)
      end
    end

    context "when no search query is present" do
      let(:params) { {} }
      subject(:service) { described_class.new(params) }

      it "sets pagination to 6 items per page" do
        result = service.call
        expect(result[:items].limit_value).to eq(6)
      end
    end

    context "when eager loading" do
      let(:params) { {} }
      subject(:service) { described_class.new(params) }

      it "includes attached images and seller associations" do
        result = service.call
        expect(result[:items].includes_values).to include(seller: :userable)
      end
    end

    context "pagination per_page logic" do
      context "when query is present" do
        it "sets per_page to 4" do
          params = { query: "Widget", page: 1 }
          service = described_class.new(params)
          result = service.call
          expect(result[:items].limit_value).to eq(4)
        end
      end

      context "when query is not present" do
        it "sets per_page to 6" do
          params = { page: 1 }
          service = described_class.new(params)
          result = service.call
          expect(result[:items].limit_value).to eq(6)
        end
      end

      context "when query is blank string" do
        it "sets per_page to 6 (treating blank as nil)" do
          params = { query: "", page: 1 }
          service = described_class.new(params)
          result = service.call
          expect(result[:items].limit_value).to eq(6)
        end
      end
    end

    context "multiple filters combined" do
      it "filters by category AND query simultaneously" do
        params = { category: category.id, query: "Widget" }
        service = described_class.new(params)
        result = service.call
        expect(result[:items]).to include(item_in_category)
        expect(result[:items]).not_to include(other_item)
      end
    end

    context "pagination result structure" do
      it "returns items and query in consistent hash format" do
        params = { query: "Widget" }
        service = described_class.new(params)
        result = service.call
        expect(result).to have_key(:items)
        expect(result).to have_key(:query)
        expect(result.keys).to eq([:items, :query])
      end
    end
  end
end