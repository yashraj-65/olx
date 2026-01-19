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
                    render json: {error: "cant delete review"},status: :forbidden
                end
            end

            def create
            @review = Review.new(review_params)
            @review.reviewer_id = current_user.id

            if @review.save
            render json: @review.as_json(include: [:deal, :seller]), status: :created
            else
            render json: { errors: @review.errors.full_messages }, status: :unprocessable_entity
            end
        end


        private

        def review_params
            params.require(:review).permit(:comment, :rating)
        end


        end

    end
end
