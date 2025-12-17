class AddNewRefsReviews < ActiveRecord::Migration[7.2]
  def change
    add_reference :reviews, :deal, null: false
  end
end
