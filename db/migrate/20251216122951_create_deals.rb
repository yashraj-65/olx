class CreateDeals < ActiveRecord::Migration[7.2]
  def change
    create_table :deals do |t|
      t.decimal :agreed_price
      t.integer :status
      t.boolean :seller_marked_done
      t.boolean :buyer_marked_done
      
      t.timestamps
    end
  end
end
