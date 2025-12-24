class Buyer < ApplicationRecord
    belongs_to :userable, polymorphic: true
   has_many :deals, through: :conversations
    has_many :likes, dependent: :destroy
    has_many :reviews, foreign_key: :reviewer_id
    has_many :conversations
end
