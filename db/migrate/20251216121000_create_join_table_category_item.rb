class CreateJoinTableCategoryItem < ActiveRecord::Migration[7.2]
  def change
    create_join_table :categories, :items do |t|
    t.index [:item_id, :category_id]
    t.index [:category_id, :item_id]
    end
  end

end
