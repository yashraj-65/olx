ActiveAdmin.register Seller do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :userable_type, :userable_id, :avg_rating, :contact_number

  filter :avg_rating
  filter :contact_number

  index do
    selectable_column
    id_column
    column :avg_rating
    column :contact_number
    actions
  end


  #
  # or
  #
  # permit_params do
  #   permitted = [:userable_type, :userable_id, :avg_rating, :contact_number]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
