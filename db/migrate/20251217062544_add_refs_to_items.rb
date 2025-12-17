class AddRefsToItems < ActiveRecord::Migration[7.2]
  def change
    add_reference :items, :seller, null: false
  end
end
