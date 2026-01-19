require 'rails_helper'

RSpec.describe Like, type: :model do
let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:seller) { create(:seller, userable: user1) }
  let(:buyer) { create(:buyer, userable: user2) }
  let(:item) { create(:item, seller: seller) }
    describe "callback" do
        it "automatcialyy sets seller_id from convo" do
                conversation = Conversation.new(item: item, buyer_profile: buyer)
      
      # Trigger validations (which triggers the callback)
      conversation.valid?
      
      expect(conversation.seller_id).to eq(item.seller_id)
      expect(conversation.seller_id).not_to be_nil
        end
    end
    describe "ransackable attributes" do 
            it "allows ransackable attributes" do
                expected_attributes = ["id", "item_id","buyer_id","seller_id"]
                expect(Conversation.ransackable_attributes).to match_array(expected_attributes)
            end
            it "allows ransackable associations" do
                expected_associations =  ["messages", "deals","buyer_profile","seller_profile"]
                expect(Conversation.ransackable_associations).to match_array(expected_associations)
            end
    end

end