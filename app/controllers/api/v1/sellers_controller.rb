module Api
    module V1
        class SellersController < BaseController
                    def index
                        @sellers = Seller.includes(:userable)
                    end
                    def show
                        @seller = Seller.find(params[:id])
                    end
                    def update
                    @seller = current_user.seller 
                    if @seller && @seller.id == params[:id].to_i
                        if @seller.update(edit_params)
                        render json: { message: "Update successful", seller: @seller }, status: :ok
                        else
                        render json: { errors: @seller.errors.full_messages }, status: :unprocessable_entity
                        end
                    else
                        render json: { error: "You can only edit your own profile" }, status: :forbidden
                    end
                    end

                    private

                    def edit_params
                        params.fetch(:seller, params).permit(:avg_rating,:contact_number)
                    end
        end
    end
end
