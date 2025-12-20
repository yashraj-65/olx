class SellersController < ApplicationController
    def show
        @seller=Seller.find(params[:id])
        @reviews=@seller.reviews.includes(:reviewer)
        @average_rating=@reviews.average(:rating).to_f.round(1)
        @items=@seller.items
    end
end
