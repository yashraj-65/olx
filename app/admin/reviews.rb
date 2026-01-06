ActiveAdmin.register Review do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :comment, :rating, :reviewer_id, :seller_id, :deal_id

  batch_action :edit_rating, form: -> {
    { new_rating: :number } 
    } do |ids, inputs|
        rating_val = inputs[:new_rating].to_f
    Review.where(id: ids).update_all(rating: rating_val)
    redirect_to collection_path, notice: "Selected reviews updated to #{rating_val} stars."
  end
  scope "Highly Rated" do |reviews|
    reviews.where("rating > ?",3)
  end
  filter :comment
  filter :rating

  index do
    selectable_column
    id_column
    column :comment
    column :rating
    column :reviewer
    column :seller
    column "Deal ID", :deal_id
    column :created_at
    actions
  end


  form do |f|
    f.semantic_errors
    f.inputs "Review Details" do
      f.input :reviewer_id, as: :select, collection: Buyer.all.map { |b| [b.userable.name, b.id] }
      f.input :seller_id, as: :select, collection: Seller.all.map { |s| [s.userable.name, s.id] }
      f.input :deal_id, as: :select, collection: Deal.all.map { |d| ["Deal ##{d.id} - $#{d.agreed_price}", d.id] }
      f.input :rating, as: :number, input_html: { min: 1, max: 5 }
      f.input :comment
    end
    f.actions
  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:comment, :rating, :reviewer_id, :seller_id, :deal_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
