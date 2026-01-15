module Api
  module V1
    class ItemsController < BaseController
      def index
        @items = Item.includes(seller: :userable).all

      end

      def show
        @item = Item.find(params[:id])

      end
      def update
          @item = Item.find(params[:id])
          if @item.seller_id == current_user.seller&.id
              if @item.update(item_params)
                render :show, status: :ok
              else
               render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
              end
              else
              render json: { error: "Unauthorized" }, status: :forbidden
          end
      end
        def create
          @item=Item.new(item_params)
          @item.seller_id=current_user.seller&.id
          if @item.save
            render :show, status: :ok
          else
            render json: {errors: @item.errors.full_messages}, status: :unprocessable_entity
          end
        end
      def destroy
        @item=Item.find(params[:id])
     if  @item.seller_id == current_user.seller&.id
          @item.destroy
          render json: {message: "Item destroyed succefully"}, status: :ok
        else
          render json: {error: "You are not authorized  to delete" }, status: :forbidden
        end
      end

      def item_params
        params.require(:item).permit(:title, :desc, :price, :status, :condition, :color,:image, category_ids: [])
      end
    end
  end
end