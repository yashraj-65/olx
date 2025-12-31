class Deal < ApplicationRecord
    enum :status, {failed: 0,success: 1}
    belongs_to :conversation
    belongs_to :item
    has_one :seller, through: :conversation ,source: :seller_profile
    has_one :buyer, through: :conversation, source: :buyer_profile
    belongs_to :proposer, class_name: "User", foreign_key: :proposer_id
    has_many :reviews
    def respondent
    proposer == buyer ? seller : buyer
    end

    after_update :mark_item_as_sold, if: :all_parties_confirmed?

    private

    def all_parties_confirmed?
        buyer_marked_done && seller_marked_done && (saved_change_to_buyer_marked_done? || saved_change_to_seller_marked_done?)
    end
    def mark_item_as_sold   
    item.sold!

    buyer.refresh_stats!
    end

    def self.ransackable_attributes(auth_object = nil)      
      ["id", "agreed_price", "status","seller_marked_done","buyer_marked_done","conversation_id","proposer_id","item_id"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["item", "reviews","conversations","userable","seller","buyer","proposer"]
    end
end
