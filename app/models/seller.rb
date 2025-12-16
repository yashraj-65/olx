class Seller < ApplicationRecord
    belongs_to :userable, polymorphic: true
end
