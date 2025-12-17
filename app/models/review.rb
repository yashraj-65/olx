class Review < ApplicationRecord
    has_many :likes, as: :likeable
    belongs_to :reviewer, class_name:'Buyer', foreign_key: 'reviewer_id'
    belongs_to :seller
    belongs_to :deal
end