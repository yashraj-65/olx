FactoryBot.define do
  factory :buyer do
    association :userable, factory: :user
    purchase_count {2}


  end
end