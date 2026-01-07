class Buyer < ApplicationRecord
    belongs_to :userable, polymorphic: true
     has_many :conversations
     has_many :deals, through: :conversations, source: :deals
     has_many :likes, dependent: :destroy
     has_many :reviews, foreign_key: :reviewer_id
   

       def refresh_stats!
        completed_deals = deals.where(status: :success)

        update!(
          purchase_count: completed_deals.count,
          total_spent: completed_deals.sum(:agreed_price)
        )
      end
    private
      def self.ransackable_attributes(auth_object = nil)
        ["created_at", "id", "purchase_count", "total_spent", "updated_at", "userable_id", "userable_type"]
      end

      def self.ransackable_associations(auth_object = nil)
        ["userable", "items", "likes","reviews"]
      end

end
