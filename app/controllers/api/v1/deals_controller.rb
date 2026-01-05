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
        end
    end
end
