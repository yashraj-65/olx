FactoryBot.define do
  factory :seller do
    association :userable, factory: :user
    contact_number { "9876543210" }
    avg_rating { "4.5" }
  end
end