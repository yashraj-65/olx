class Review < ApplicationRecord
    has_many :likes, as: :likeable
    belongs_to :reviewer, class_name:'Buyer', foreign_key: 'reviewer_id'
    belongs_to :seller
    belongs_to :deal
    validates :rating, presence: true,inclusion: { in: 1..5 },numericality: { 
                       # Optional: ensures they don't enter 4.55555
                       # Only allows up to 1 decimal place (e.g., 4.5)
                       less_than_or_equal_to: 5,
                       greater_than_or_equal_to: 1
                     }
end