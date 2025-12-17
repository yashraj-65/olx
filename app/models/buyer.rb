class Buyer < ApplicationRecord
    belongs_to :userable, polymorphic: true
    has_many :deals
    has_many :reviews, foreign_key: :reviewer_id
end
