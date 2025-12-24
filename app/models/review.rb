class Review < ApplicationRecord
    has_many :likes, as: :likeable
    belongs_to :reviewer, class_name:'Buyer', foreign_key: 'reviewer_id'
    belongs_to :seller
    belongs_to :deal
    validates :rating, presence: true,inclusion: { in: 1..5 },numericality: { 
                       less_than_or_equal_to: 5,
                       greater_than_or_equal_to: 1
                     }
    
end