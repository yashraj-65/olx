class User < ApplicationRecord
    has_one :buyer, as: :userable
    has_one :seller, as: :userable

    has_many :likes
    has_many :reviews   
end
