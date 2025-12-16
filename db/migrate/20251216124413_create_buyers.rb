class CreateBuyers < ActiveRecord::Migration[7.2]
  def change
    create_table :buyers do |t|
      t.references :userable, polymorphic: true, index: true
      t.integer :purchase_count, default: 0
      t.integer :total_spent, default: 0
      t.timestamps
    end
  end
end
