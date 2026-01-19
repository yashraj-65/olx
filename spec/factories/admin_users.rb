FactoryBot.define do
    factory :admin_user do
        sequence(:email) { |n| "admin#{n}@olx.com" }
        password { "Password123!" }
        password_confirmation { "Password123!" }
    end
end