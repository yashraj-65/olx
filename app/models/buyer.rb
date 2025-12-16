class Buyer < ApplicationRecord
    belongs_to :userable, polymorphic: true
end
