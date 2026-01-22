class SellersController < ApplicationController
  include Pagy::Backend
  before_action :set_seller_and_user, only: :show

  def show
    all_reviews = @seller.reviews.includes(:reviewer)
    @average_rating = all_reviews.average(:rating).to_f.round(1)
    @pagy_reviews, @reviews = pagy(all_reviews, limit: 5, page_param: :reviews_page)

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
    @pagy_sold, @sold_items = pagy(@user.sold_items, 
                                      limit: 2, 
                                      page_param: :sold_page)
  if @user.buyer
    @pagy_bought, @bought_items = pagy(@user.bought_items, 
                                           limit: 2, 
                                           page_param: :bought_page)
  else
    @bought_items = []
  end
end

end
