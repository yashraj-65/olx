module Api
  module V1
    class UsersController < BaseController
      def index
        @users = User.all
        render json: @users.as_json(
          only: [:id, :name, :email],
          include: {
            # 1. Get items the user is selling
            seller: {
              only: [:id, :avg_rating],
              include: {
                items: { only: [:id, :title, :price, :status] }
              }
            },

            buyer: {
              only: [:id, :purchase_count, :total_spent]
            }
          }
        )
      end

      def show
        @users = User.find(params[:id])
        render json: @users.as_json(
          only: [:id, :name, :email],
          include: {
            # 1. Get items the user is selling
            seller: {
              only: [:id, :avg_rating],
              include: {
                items: { only: [:id, :title, :price, :status] }
              }
            },
            # 2. Get information about them as a buyer
            buyer: {
              only: [:id, :purchase_count, :total_spent]
            }
          }
        )
      end

  

    end
  end
end