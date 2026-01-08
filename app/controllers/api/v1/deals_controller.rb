module Api
    module V1
        class DealsController < BaseController
            def index
            @deals=Deal.all
            render json: @deals.as_json(
                only: [:id,:agreed_price,:seller_marked_done,:buyer_marked_done],
                include: {
                    item: {
                        only: [:id, :title, :status]
                    }
                }
            )
            end
            def show
                @deal=Deal.find(params[:id])
                render json: @deal.as_json(
                    only: [:id, :agreed_price,:seller_marked_done,:buyer_marked_done],
                    include: {
                        item: {
                            only: [:id, :title, :status]
                        }
                    }
                )
            end
            def mark_sold
                @deal =Deal.find(params[:id])
                if @deal.seller.id = current_user.id
                    @deal.update(seller_marked_done: true)
                    render json: {message: "seller confirmed", deal: @deal}
                elsif @deal.buyer.id=current_user.id
                    @deal.update(buyer_marked_done: true)
                    render json: {message: "seller confirmed", deal: @deal}
                else
                   render json: {message: "user not part of deal", status: :forbidden}
                end

            end
            def update
                @deal = Deal.find(params[:id])
                if @deal.seller.id == current_user.id || @deal.buyer.id == current_user.id
                    @deal.update(deal_params)
                end
                if @deal.save
                    render json: {message: "sucefully updated", deal: @deal}, status: :ok
                else
                     render json: {message: "failed updat", deal: @deal}, status: :unprocessable_entity
                end
            end
            

            def deal_params
                
            end
        end
    end
end
