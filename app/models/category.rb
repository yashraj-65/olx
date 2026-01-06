class Category < ApplicationRecord
    has_and_belongs_to_many :items
    enum :kind, [:electronics, :vehicles, :furniture, :clothing, :other]

    def self.ransackable_attributes(auth_object = nil)
        ["kind", "id", "created_at"]
    end   
    def self.ransackable_associations(auth_object = nil)
        ["items"]
    end
end
