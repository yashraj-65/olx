class Like < ApplicationRecord
    belongs_to :buyer
    belongs_to :likeable, polymorphic: true
end
