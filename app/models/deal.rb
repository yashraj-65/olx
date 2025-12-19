class Deal < ApplicationRecord
    enum status: {success: 1, failed: 0}
    belongs_to :conversation
    belongs_to :item
    has_one :seller, through: :conversation 
    has_one :buyer, through: :conversation
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
    end

end
