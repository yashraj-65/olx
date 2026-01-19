class Conversation < ApplicationRecord
    belongs_to :item
    belongs_to :buyer_profile, class_name: 'Buyer', foreign_key:'buyer_id'
    belongs_to :seller_profile, class_name: 'Seller', foreign_key:'seller_id'
    has_many :messages, dependent: :destroy
    has_many :deals, dependent: :destroy
    validates :item_id, :buyer_id, presence: true 
    before_validation :set_seller_from_item, on: :create
    def self.ransackable_attributes(auth_object = nil)      
      ["id", "item_id","buyer_id","seller_id"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["messages", "deals","buyer_profile","seller_profile"]
    end
    
    private
  def set_seller_from_item
    self.seller_id = item.seller_id if item.present?
  end
end
