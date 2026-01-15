FactoryBot.define do
    factory :conversation do
        
   
        association :item
        association :buyer_profile, factory: :buyer
        association :seller_profile, factory: :seller
       
    end
end