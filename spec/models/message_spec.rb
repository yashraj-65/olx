require 'rails_helper'

RSpec.describe Message, type: :model do
    describe "ransackable attributes" do 
        it "allows ransackable attributes" do
            expected_attributes =    ["id","body","conversation_id","user_id"]
            expect(Message.ransackable_attributes).to match_array(expected_attributes)
        end
         it "allows ransackable associations" do
            expected_associations =    ["conversation","user"]
            expect(Message.ransackable_associations).to match_array(expected_associations)
        end
    end
describe "validations" do
  it "is invalid with an empty body" do
      message = build(:message, body: "")
      expect(message).not_to be_valid
    end

    it "is valid with a body of 2 or more characters" do
      message = build(:message, body: "Hi")
      expect(message).to be_valid
    end
end
describe "callbacks" do
    let(:user) { create(:user) }
     let(:user2) { create(:user) }
    let(:seller) { create(:seller,userable: user) }
    let(:item) { create(:item, seller: seller) }
    let(:buyer) { create(:buyer,userable: user2) }
    let(:conversation) { create(:conversation, item: item, buyer_profile: buyer) }

    it "broadcasts to the messages_list target after creation" do
      message = Message.new(conversation: conversation, user: user, body: "Hello!")
      expect(message).to receive(:broadcast_append_to).with(
        conversation, 
        target: "messages_list"
      )
      
      message.save!
    end
  end
end