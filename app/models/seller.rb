class Seller < ApplicationRecord
    belongs_to :userable, polymorphic: true
    has_many :deals, through: :conversations
    has_many :reviews
    has_many :items
    has_many :conversations
end
