class Like < ApplicationRecord
    belongs_to :buyer
    belongs_to :likeable, polymorphic: true
    validates :buyer_id, uniqueness: {scope: [:likeable_id, :likeable_type]}

    
end
