
FactoryBot.define do
  factory :item do
    title { "Test product" }
    price { 200 }
    desc { "new product very good!" }
    association :seller
  end
end