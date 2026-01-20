FactoryBot.define do
  factory :message do
    body { Faker::Lorem.sentence(word_count: 5) }

    association :conversation
    association :user

    trait :long do
      body { Faker::Lorem.paragraph(sentence_count: 5) }
    end

    trait :from_seller do
      association :user, factory: :user 
    end
  end
end