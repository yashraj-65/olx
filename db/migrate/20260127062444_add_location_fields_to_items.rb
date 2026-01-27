class AddLocationFieldsToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :address, :string
    add_column :items, :latitude, :decimal, precision: 10, scale: 6
    add_column :items, :longitude, :decimal, precision: 10, scale: 6
    
    add_index :items, [:latitude, :longitude]
    add_index :items, :address
  end
end
