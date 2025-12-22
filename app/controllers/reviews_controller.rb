class ReviewsController < ApplicationController
    def create_review
        @deal=Deal.find(params[:deal_id])
        @seller=@deal.item.seller
        

        @review = @deal.reviews.build(review_params)
        @review.reviewer=current_user.buyer
        @review.seller=@seller

        if @review.save
            redirect_to item_path(@deal.item)
        else
            redirect_to item_path(@deal.item), alert:"deal failed!!!!"
        end
    end
def destroy
  @review = Review.find(params[:id])
  
  if @review.reviewer == current_user.buyer
    @review.destroy
    redirect_back fallback_location: root_path, notice: "Review deleted."
  else
    redirect_back fallback_location: root_path, alert: "Not authorized."
  end
end
    private

  
        def review_params
            params.require(:review).permit(:comment,:rating)
        end
    
end
