class RenameTypeInCategories < ActiveRecord::Migration[7.2]
  def change
    rename_column :categories, :type, :kind
  end
end