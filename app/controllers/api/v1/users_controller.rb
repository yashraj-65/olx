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


      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :description, :avatar)
      end
      def edit_params
        params.require(:user).permit(:name,:description, :avatar)
      end

    end
  end
end