FactoryBot.define do
  factory :like do
    association :buyer 
    association :likeable, factory: :item 
  end
end