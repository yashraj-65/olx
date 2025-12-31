class Seller < ApplicationRecord
    belongs_to :userable, polymorphic: true
    has_many :deals, through: :conversations, source: :deals
    has_many :reviews
    has_many :items
    has_many :conversations
    private
    
      def self.ransackable_attributes(auth_object = nil)
        ["id", "avg_rating","contact_number", "created_at", "updated_at", "userable_id", "userable_type"]
      end

      def self.ransackable_associations(auth_object = nil)
        ["userable", "items","reviews","deals"]
      end

end
