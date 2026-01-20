ActiveAdmin.register Item do
  permit_params :title, :desc, :status, :warranty, :color, :price, 
                :condition, :is_negotiable, :seller_id, :image, category_ids: []

 batch_action :make_avail do |ids|
  Item.where(id: ids).update_all(status: :available)

  redirect_to collection_path, notice: "items have been made available"
 end

  batch_action :add_category, form: -> {
  { category_id: Category.all.map { |c| [c.kind.humanize, c.id] } }
  } do |ids, inputs|
    puts "DEBUG: Received IDs: #{ids.inspect}" 
  puts "DEBUG: Received Inputs: #{inputs.inspect}"
  category = Category.find(inputs[:category_id]) 
  items = Item.find(ids)

  items.each do |item|
    item.categories << category unless item.categories.include?(category)
  end

  redirect_to collection_path, notice: "Category added to selected items."
end

scope :available
scope :sold
Category.kinds.keys.map.each do |kind_name|
  scope kind_name.humanize do  |items|
    items.joins(:categories).where(categories: {kind: kind_name})
  end
end

  filter :title
filter :seller_userable_of_User_type_name_cont, as: :string, label: "Seller Name"
filter :seller_id_eq, as: :string, label: "Seller ID"
  filter :status, as: :select, collection: Item.statuses
  filter :condition, as: :select, collection: Item.conditions
  filter :price
  filter :categories_kind, as: :select, 
         collection: Category.kinds.keys.map { |k| [k.humanize, Category.kinds[k]] },
         label: "Category Type"

  index do
    selectable_column
    id_column
    column :title
    column :seller
    column "Categories" do |item|
      item.categories.map(&:kind).join(",")
    end
    column :status do |item|
      status_tag item.status 
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
      f.input :price,input_html: { min: 0 }
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