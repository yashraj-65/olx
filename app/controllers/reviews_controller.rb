class ReviewsController < ApplicationController
    def create_review
        @deal=Deal.find(params[:deal_id])
        @seller=@deal.item.seller
        

        @review = @deal.reviews.build(review_params)
        @review.reviewer=current_user.buyer
        @review.seller=@seller

        if @review.save
            redirect_to @deal.item
        elsif
            redirect_to @deal.item, alert;"deal failed!!!!"
        end
    end

    private

  
        def review_params
            params.require(:review).permit(:comment,:rating)
        end
    
end
