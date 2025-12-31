ActiveAdmin.register Buyer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :userable_type, :userable_id, :purchase_count, :total_spent
   filter :userable_id
   filter :purchase_count
   filter :total_spent
  
   index do
    selectable_column
    id_column
    column :purchase_count
    column :total_spent
    actions
   end
  #
  # or
  #
  # permit_params do
  #   permitted = [:userable_type, :userable_id, :purchase_count, :total_spent]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
