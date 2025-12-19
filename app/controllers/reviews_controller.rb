class ReviewsController < ApplicationController
    def create_review
        @deal=Deal.find(params[:deal_id])
        @seller=@deal.item.seller
        

        @review = @deal.build_review(review_params)
        @review.reviewer=current_buyer
        @review.seller=seller

        if @review.save
            redirect_to @deal
        elsif
            redirect_to @deal, alert;"deal failed!!!!"
        end
    end

    private

    def review_params
        def review_params
            params.require(:review).permit(:comment,:rating)
        end
    end
end
