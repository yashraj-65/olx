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
                        is_admin = current_user.is_a?(AdminUser)
is_owner = (@seller.userable_id == current_user.id && @seller.userable_type == current_user.class.name)
                        if is_admin || is_owner
                            if @seller.update(edit_params)
                            render json: { message: "Update successful", seller: @seller }, status: :ok
                            else
                            render json: { errors: @seller.errors.full_messages }, status: :unprocessable_entity
                            end
                        else
                            # 403 Forbidden: Neither an Admin nor the Owner
                            render json: { error: "not authorised" }, status: :forbidden
                        end
                    end

                    private

                    def edit_params
                        params.require(:seller).permit(:avg_rating,:contact_number)
                    end
        end
    end
end
