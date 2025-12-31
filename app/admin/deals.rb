ActiveAdmin.register Deal do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :agreed_price, :status, :seller_marked_done, :buyer_marked_done, :conversation_id, :proposer_id, :item_id

   
   filter :agreed_price
   filter :status, as: :select, collection: [["Success", 1], ["Failed", 0]]
   filter :seller_marked_done
   filter :proposer, collection: -> { User.order(:name).pluck(:name, :id) }
   

   index do
    selectable_column
    id_column
    column :item_id
    column "Proposer" do |deal|
    deal.proposer&.name || "N/A"
    end
    column :agreed_price
    column :status
    column :seller_marked_done
    column :buyer_marked_done
    actions
   end
  #
  # or
  #
  # permit_params do
  #   permitted = [:agreed_price, :status, :seller_marked_done, :buyer_marked_done, :conversation_id, :proposer_id, :item_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
