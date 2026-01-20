FactoryBot.define do
  factory :review do
    rating {4.0}
    
    association :deal 
    association :seller
    association :reviewer, factory: :buyer
  end
end