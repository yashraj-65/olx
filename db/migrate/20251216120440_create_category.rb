class CreateCategorys  < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.integer :type
      t.text :desc
      t.timestamps
    end
  end
end
