module Api
    module V1
        class SellersController < BaseController
                    def index
                    
                        @sellers = Seller.includes(:userable)

                        
                        if params[:name].present?
                        @sellers = @sellers.joins(:userable).where("users.name ILIKE ?", "%#{params[:name]}%")
                        end

                        if params[:active].present?
                        @sellers = @sellers.where(active: params[:active] == 'true')
                        end


                    end
                    def show
                        @seller = Seller.find(params[:id])

                    end
                    def update
                        @seller = Seller.find(params[:id])
                        if @seller.userable = current_user
                            if @seller.update(edit_params)
                                    render json: { message: "Seller updated successfully", seller: @seller }, status: :ok
                            else
                                render json: {errors: @seller.errors.full_messages},status: :unprocessable_entity
                            end
                        else
                                      render json: {error:"not authorised"},status: :forbidden
                        end
                    end

                    private

                    def edit_params
                        params.require(:seller).permit(:avg_rating,:contact_number)
                    end
        end
    end
end
