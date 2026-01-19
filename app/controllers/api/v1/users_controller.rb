module Api
  module V1
    class UsersController < BaseController
      skip_before_action :doorkeeper_authorize!, only: [:create]
      def index
        @users = User.all

      end

      def show
        @user = User.find(params[:id])
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render json: { message: "User creation successful", user: @user }, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      def update
        @user = User.find(params[:id])
        if @user == current_user
          if @user.update(edit_params)
            render :show, status: :ok
          else
            render json: {errors: @user.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: {error:"not authorised"},status: :forbidden
        end
      end

    def destroy

      
      @user_to_delete = User.find(params[:id])

      if current_user.is_a?(AdminUser) 
        if @user_to_delete.destroy
          render json: { message: "User deleted successfully" }, status: :ok
        else
          render json: { errors: @user_to_delete.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { message: "Not authorized: Only active admins can perform this action" }, status: :forbidden
      end
    end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :description, :avatar)
      end
      def edit_params
        params.require(:user).permit(:name, :description, :avatar)
      end

    end
  end
end


# POLYMORPHIC LOOKUP:
          # doorkeeper_token.resource_owner_type will be a string like "AdminUser" or "User"
          # .constantize turns that string into the actual Ruby Class
          # .find_by searches that specific table for the ID
# FALLBACK LOOKUP:
          # If the database doesn't have the 'type' column yet, we try the Admin table first.
          # If nothing is found there, we search the regular User table.