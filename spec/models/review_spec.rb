require 'rails_helper'

RSpec.describe Like, type: :model do
let(:user) { create(:user) }
  let(:seller) { create(:seller, userable: user, avg_rating: 0.0) }
  let(:buyer) { create(:buyer) }
  let(:deal) { create(:deal, seller: seller, buyer: buyer) }
    describe "callback" do
        it "updates the seller's avg_rating when a review is created" do
      expect {
        create(:review, seller: seller, deal: deal, reviewer: buyer, rating: 5)
      }.to change { seller.reload.avg_rating.to_f}.from(0.0).to(5.0)
    end
    end
    describe "ransackable attributes" do 
            it "allows ransackable attributes" do
                expected_attributes = ["id", "comment", "rating"]
                expect(Review.ransackable_attributes).to match_array(expected_attributes)
            end
            it "allows ransackable associations" do
                expected_associations =       ["seller", "deals"]
                expect(Review.ransackable_associations).to match_array(expected_associations)
            end
    end

end