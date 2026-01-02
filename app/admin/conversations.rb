ActiveAdmin.register Conversation do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :item_id, :buyer_id, :seller_id
   index do
    selectable_column
    id_column
    column :item
    column "Buyer" do |conversation|
      conversation.buyer_profile.userable.name
    end
    column "seller" do |conversation|
      conversation.seller_profile.userable.name
    end
    column :buyer_id
    column :seller_id
   end

  #
  # or
  #
  # permit_params do
  #   permitted = [:item_id, :buyer_id, :seller_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
