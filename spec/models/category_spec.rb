require 'rails_helper'

RSpec.describe Category, type: :model do
    describe "ransackable attributes" do 
        it "allows ransackable attributes" do
            expected_attributes =  ["kind", "id", "created_at"]
            expect(Category.ransackable_attributes).to match_array(expected_attributes)
        end
         it "allows ransackable associations" do
            expected_associations =   ["items"]
            expect(Category.ransackable_associations).to match_array(expected_associations)
        end
    end
end