module Api
  module V1
    class ItemsController < BaseController
      def index
        @items = Item.all
        render json: @items.as_json(
          only: [:id, :title, :price, :status, :condition],
          include: { 
            seller: { 
              only: [:id, :avg_rating], 
              include: { 
                userable: { only: [:name, :email] } 
              } 
            } 
          }
        )
      end

      def show
        @item = Item.find(params[:id])
        render json: @item.as_json(
          only: [:id, :title, :price, :desc, :condition],
          include: { 
            seller: { 
              include: { userable: { only: [:name] } } 
            } 
          }
        )
      end
    end
  end
end