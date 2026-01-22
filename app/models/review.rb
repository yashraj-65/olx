class Review < ApplicationRecord
    acts_as_paranoid
    has_many :likes, as: :likeable
    belongs_to :reviewer, class_name:'Buyer', foreign_key: 'reviewer_id'
    belongs_to :seller
    belongs_to :deal
    validates :rating, presence: true,inclusion: { in: 1..5 },numericality: { 
                       less_than_or_equal_to: 5,
                       greater_than_or_equal_to: 1
                     }
    after_commit  :update_seller_rating, on: [:create,:destroy, :update]

    def self.ransackable_attributes(auth_object = nil)      
      ["id", "comment", "rating"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["seller", "deals"]
    end
    private

  def update_seller_rating
     new_average = seller.reviews.average(:rating).to_f.round(2)
     seller.update(avg_rating: new_average)
end
    
end