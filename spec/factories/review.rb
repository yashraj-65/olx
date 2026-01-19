FactoryBot.define do
  factory :review do
    rating {4.0}
    
    association :deal 
    association :seller
  end
end