ActiveAdmin.register Message do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :body, :conversation_id, :user_id

   scope "Recent Messages" do |messages|
    messages.where('created_at > ?', 1.week.ago)
  end

   filter :user_id, as: :select, collection: ->{User.pluck(:name, :id)},label: 'sender name'
   index do
    selectable_column
    id_column
    column :body
    column :conversation_id
    column "Sender" do |message|
      message.user.name
    end
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:body, :conversation_id, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
