class Conversation < ApplicationRecord
    belongs_to :item
    belongs_to :buyer_profile, class_name: 'Buyer', foreign_key:'buyer_id'
    belongs_to :buyer_profile, class_name: 'Seller', foreign_key:'seller_id'
    has_many :messages, dependant: :destroy
    has_one :deal
end
