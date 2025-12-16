class CreateSellers < ActiveRecord::Migration[7.2]
  def change
    create_table :sellers do |t|
      t.references :userable, polymorphic: true, index: true
      t.string :avg_rating
      t.string :contact_number
      t.timestamps
    end
  end
end
