class Category < ApplicationRecord
    has_and_belongs_to_many :items
    enum :kind, [:electronics, :vehicles, :furniture, :clothing, :other]
end
