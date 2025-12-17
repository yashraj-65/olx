class RenameTypoInDeals < ActiveRecord::Migration[7.2]
  def change
    rename_column :deals, :items_id , :item_id
  end
end
