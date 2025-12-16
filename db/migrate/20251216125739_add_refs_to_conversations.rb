class AddRefsToConversations < ActiveRecord::Migration[7.2]
  def change
    add_reference :conversations, :item, null: false, foreign_key: true
    add_reference :conversations, :buyer, null: false, foreign_key: true
    add_reference :conversations, :seller, null: false, foreign_key: true
  end
end
