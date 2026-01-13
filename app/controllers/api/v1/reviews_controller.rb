module Api
    module V1
        class ReviewsController < BaseController

            before_action :doorkeeper_authorize!


            def index
                @reviews=Review.includes({seller: :userable}, :deal).all
            end


            def show
                @review=Review.find(params[:id])
                render json: @review.as_json(
                only: [:id, :comment, :rating, :seller_id, :reviewer_id],
                include: {
                    deal: {
                    only: [:id, :agreed_price]
                    },
                    seller: {
                    only: [:id, :avg_rating, :contact_number]
                    }
                }
                )
            end

            def destroy
                @review = Review.find(params[:id])
                if @review.reviewer_id == current_user.id
                    @review.destroy
                    render json: {message: "Review deleted"},status: :ok
                else
                    render json: {error: "cant delete review"},status: :unprocessable_entity
                end
            end


        end

    end
end
