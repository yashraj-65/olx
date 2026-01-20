FactoryBot.define do
  factory :category do
    kind { :electronics } 

    trait :furniture do
      kind { :furniture }
    end

    trait :vehicles do
      kind { :vehicles }
    end
  end
end