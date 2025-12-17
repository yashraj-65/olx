class User < ApplicationRecord
    has_one :buyer, as: :userable
    has_one :seller, as: :userable
    has_many :messages
    has_many :likes
    has_many :reviews_as_reviewer, through: :buyer, source: :reviews
    has_many :reviews_as_seller, through: :seller, source: :reviews
    has_many :deals_as_buyer, through: :buyer, source: :deals
    has_many :deals_as_seller, through: :seller, source: :deals
    
     validates :name, presence: true, length: {minimum: 3}
     
    private
   
    def create_default_buyer
        self.create_buyer
    end

end
