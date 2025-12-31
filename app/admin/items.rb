ActiveAdmin.register Item do
  permit_params :title, :desc, :status, :warranty, :color, :price, 
                :condition, :is_negotiable, :seller_id, :image, category_ids: []

  # This cleans up the filters on the right sidebar
  filter :title
  filter :seller
  filter :status, as: :select, collection: Item.statuses
  filter :condition, as: :select, collection: Item.conditions
  filter :price

  index do
    selectable_column
    id_column
    column :title
    column :seller
    column :status do |item|
      status_tag item.status # Makes pretty colored tags (green for available, etc.)
    end
    column :price
    column :condition
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs "Item Details" do
      f.input :seller, collection: Seller.all.map { |s| [s.userable.name, s.id] }
      f.input :title
      f.input :desc
      f.input :categories, as: :check_boxes
      f.input :price
    end
    
    f.inputs "Specifications" do
      f.input :status, as: :select, collection: Item.statuses.keys
      f.input :condition, as: :select, collection: Item.conditions.keys
      f.input :color
      f.input :warranty
      f.input :is_negotiable
    end

    f.inputs "Media" do
      f.input :image, as: :file
    end
    f.actions
  end
end