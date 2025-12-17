class AddSellerRefToReviews < ActiveRecord::Migration[7.2]
  def change
     add_reference :reviews, :seller, null:false
  end
end
