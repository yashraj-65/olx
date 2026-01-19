require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:buyer) { create(:buyer) }
  let(:item)  { create(:item) }
  
  subject { build(:like, buyer: buyer, likeable: item) }

  describe "associations" do
    it "belongs to a buyer" do
      expect(described_class.reflect_on_association(:buyer).macro).to eq(:belongs_to)
    end

    it "belongs to a likeable object (polymorphic)" do
      assoc = described_class.reflect_on_association(:likeable)
      expect(assoc.macro).to eq(:belongs_to)
      expect(assoc.options[:polymorphic]).to be true
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    context "uniqueness" do
      let!(:existing_like) { create(:like, buyer: buyer, likeable: item) }

      it "is invalid if the buyer likes the same item again" do
        duplicate_like = build(:like, buyer: buyer, likeable: item)
        
        expect(duplicate_like).not_to be_valid
        expect(duplicate_like.errors[:buyer_id]).to include("has already been taken")
      end

      it "is valid if a different buyer likes the same item" do
        other_buyer = create(:buyer)
        new_like = build(:like, buyer: other_buyer, likeable: item)
        
        expect(new_like).to be_valid
      end
      
      it "is valid if the same buyer likes a different item" do
        other_item = create(:item)
        new_like = build(:like, buyer: buyer, likeable: other_item)
        
        expect(new_like).to be_valid
      end
    end
  end
end