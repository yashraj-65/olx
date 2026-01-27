require "rails_helper"

RSpec.describe DealMailer, type: :mailer do
  describe "deal_confirmed_email" do
    let(:user_buyer) { create(:user, email: "buyer@example.com") }
    let(:user_seller) { create(:user, email: "seller@example.com") }
    
    let(:buyer) { user_buyer.buyer }
    let(:seller) {  user_seller.seller }
    
    let(:item) { create(:item, title: "Vintage Camera", seller: seller) }
    let(:deal) { create(:deal, item: item, buyer: buyer, seller: seller) }

    let(:mail) { DealMailer.deal_confirmed_email(deal) }

    it "renders the headers" do
      expect(mail.subject).to eq("Deal Confirmed: Vintage Camera")
      expect(mail.to).to contain_exactly("seller@example.com", "buyer@example.com")
      expect(mail.from).to eq(["from@example.com"]) 
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(item.title)
      expect(mail.body.encoded).to match("Deal Confirmed")
    end

    it "sends the email" do
      expect {
        mail.deliver_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end