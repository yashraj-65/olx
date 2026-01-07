ActiveAdmin.register Deal do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :agreed_price, :status, :seller_marked_done, :buyer_marked_done, :conversation_id, :proposer_id, :item_id


  batch_action :set_status_select do |ids|
    Deal.where(id: ids).update_all(status: :success)
  end


   batch_action :set_status, form: ->{
    {status: Deal.statuses.keys}
   } do |ids,inputs|
     status_value = Deal.statuses[inputs[:status]]
     Deal.where(id: ids).update_all(status: status_value)
     redirect_to collection_path, notice: "Selected deals updated to #{inputs[:status]}"
   end
   scope :all
   scope "seler marked done" do |deals|
    deals.where(seller_marked_done: true)
   end
    scope "buyer marked done" do |deals|
    deals.where(buyer_marked_done: true)
   end
   scope "completed deals" do |deals|
    deals.where(seller_marked_done: true,buyer_marked_done: true)
   end


   
   filter :agreed_price
   filter :status, as: :select, collection: [["Success", 1], ["Failed", 0]]
   filter :seller_marked_done
   filter :proposer_name_cont, as: :string, label: "Proposer Name"
   
   filter :proposer_id_eq, as: :string, label: "Proposer ID"
   index do
    selectable_column
    id_column
    column :item_id
    column "item" do |deal|
      deal.item.title
    end

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
