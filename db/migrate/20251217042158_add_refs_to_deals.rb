class AddRefsToDeals < ActiveRecord::Migration[7.2]
  def change
    add_reference :deals, :conversation, null: false, foreign_key: true
    add_reference :deals, :proposer, null: false, foreign_key: {to_table: :users}
    add_reference :deals, :items, null: false, foreign_key: true
  end
end
