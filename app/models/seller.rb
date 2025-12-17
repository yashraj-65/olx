class Seller < ApplicationRecord
    belongs_to :userable, polymorphic: true
    has_many :deals
    has_many :reviews
end
