ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :email, :password, :password_confirmation, :description

  form do |f|
    f.semantic_errors

    f.inputs "User details" do
      f.input :name
      f.input :email
      f.input :description
    end

    f.inputs "Change Password (leave blank to keep current)" do
      f.input :password
      f.input :password_confirmation
    end

    f.actions

  end

  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end


  filter :name
  filter :email


  index do
    selectable_column
    id_column
    column :name
    column :role
     column :email
    actions
  end
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :description, :role]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
