class SellersController < ApplicationController
  before_action :set_seller_and_user, only: :show

  def show
    @reviews = @seller.reviews.includes(:reviewer)
    @average_rating = @reviews.average(:rating).to_f.round(1)

   @active_listings = @seller.items.available

    if @user == current_user
      load_sold_and_bought_items
   else
    @sold_items = []
    @bought_items = []
    end
  end

  private

  def set_seller_and_user
    @seller = Seller.find(params[:id])
    @user   = @seller.userable
  end

def load_sold_and_bought_items
  @sold_items = @user.sold_items
  if @user.buyer
    @bought_items = @user.bought_items
  else
    @bought_items = []
  end
end

end
