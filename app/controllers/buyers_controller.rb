class BuyersController < ApplicationController
  before_action :set_buyer_and_user, only: :show

  def show
    @reviews = @user.seller&.reviews&.includes(:reviewer) || []
    @average_rating = @reviews.any? ? @reviews.average(:rating).to_f.round(1) : 0.0
    @active_listings = @user.seller&.items&.where(status: [:available, nil]) || Item.none
      
    if @user == current_user
        load_sold_and_bought_items
    else
      @sold_items = []
      @bought_items = []
    end
  end

  private

  def set_buyer_and_user
    @buyer = Buyer.find(params[:id])
    @user   = @buyer.userable
  end

  def load_sold_and_bought_items
    if @user.seller
      @sold_items = @user.seller.items.where(status: :sold)
    else
      @sold_items = []
    end

    if @user.buyer
      @bought_items = @user.bought_items
    else
      @bought_items = []
    end
  end


end
