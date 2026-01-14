FactoryBot.define do
    factory :user do
        name {"Test user"}
        sequence(:email) {|n| "testuser#{n}@gmail.com"}
        password { "Password123!" }
        password_confirmation { "Password123!" }
    end
end