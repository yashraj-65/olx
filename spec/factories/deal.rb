FactoryBot.define do
  factory :deal do
    agreed_price { 100.00 }
    status { :success }
    seller_marked_done { false }
    buyer_marked_done { false }
    
    association :item
    association :conversation
    association :proposer, factory: :user
  end
end