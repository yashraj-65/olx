  class AddRefsToReviews < ActiveRecord::Migration[7.2]
    def change
      add_reference :reviews, :reviewer, null: false, foreign_key: { to_table: :buyers } #creat reviewer_id and links to buyer table
    end
  end
