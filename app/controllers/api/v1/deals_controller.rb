module Api
    module V1
        class DealsController < BaseController
            def index
            @deals=Deal.includes(:item,{buyer: :userable},{seller: :userable}).all

            end
            def show
                @deal=Deal.find(params[:id])
                
            end
            def mark_sold
                @deal =Deal.find(params[:id])
                if @deal.seller&.userable_id == current_user.id
                    @deal.update(seller_marked_done: true)
                    render json: {message: "seller confirmed", deal: @deal}
                elsif @deal.buyer&.userable_id==current_user.id
                    @deal.update(buyer_marked_done: true)
                    render json: {message: "buyer confirmed", deal: @deal}
                else
                   render json: {message: "user not part of deal"}, status: :forbidden
                end

            end
            def update
                @deal = Deal.find(params[:id])
                unless @deal.seller&.userable_id == current_user.id || @deal.buyer&.userable_id == current_user.id
                    return render json: { message: "unauthorized" }, status: :forbidden
                end
                if @deal.update(item_params)
                    render json: { message: "sucefully updated", deal: @deal }, status: :ok
                else
                    render json: { message: "failed update", errors: @deal.errors }, status: :unprocessable_entity
                end
            end
            

      def item_params
        params.require(:deal).permit(:agreed_price, :status, :seller_marked_done, :buyer_marked_done, :condition, :color,:image, category_ids: [])
      end
        end
    end
end
