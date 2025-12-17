class AddRefsToLikes < ActiveRecord::Migration[7.2]
  def change
    add_reference :likes, :buyer ,null: false
    add_reference :likes, :likeable, polymorphic: true, null: false
  end
end
