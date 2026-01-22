module Api
  module V1
    class ItemsController < BaseController
      def index
        @pagy, @items = pagy(Item.includes(seller: :userable).all,limit: 10)
        @pagination = {
          count: @pagy.count,
          pages: @pagy.pages,
          current_page: @pagy.page,
          next_page: @pagy.next,
          prev_page: @pagy.prev,
          items_per_page: @pagy.limit,
        }
      end

      def show
        @item = Item.find(params[:id])

      end
      def update
          @item = Item.find(params[:id])
          if @item.seller.userable_id == current_user.id
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
            render :show, status: :created
          else
            render json: {errors: @item.errors.full_messages}, status: :unprocessable_entity
          end
        end
      def destroy
        @item=Item.find(params[:id])
        if  @item.seller.userable_id == current_user&.id
          @item.destroy
          render json: {message: "Item destroyed succefully"}, status: :ok
        else
          render json: {error: "You are not authorized  to delete" }, status: :forbidden
        end
      end

    def search_by_query
        @pagy,@items = pagy(Item.includes(seller: :userable)
                     .search_by_query(params[:query]),limit: 10)

        @pagination = {
          count: @pagy.count,
          pages: @pagy.pages,
          current_page: @pagy.page,
          next_page: @pagy.next,
          prev_page: @pagy.prev,
          items_per_page: @pagy.limit,
        }

        render :index 
    end

    def search_by_category
              @items = Item.includes(seller: :userable)
                     .filter_by_category(params[:category_id])
                     render :index 
    end
private
      def item_params
        params.require(:item).permit(:title, :desc, :price, :status, :condition, :color,:image, category_ids: [])
      end
    end
  end
end