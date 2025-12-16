class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.string :title
      t.text :desc
      t.integer :status
      t.text :warranty
      t.string :color
      t.decimal :price
      t.integer :condition
      t.boolean :is_negotiable
      t.timestamps
    end
  end
end
