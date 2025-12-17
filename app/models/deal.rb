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
end
