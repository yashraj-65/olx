class LikesController < ApplicationController

    def create
        buyer = current_user.buyer || current_user.create_buyer
        @item = Item.find(params[:item_id])

        @like = buyer.likes.find_or_initialize_by(likeable: @item)
        if @like.persisted?
            redirect_back fallback_location: root_path
        elsif @like.save
            redirect_back fallback_location: root_path, notice: "likes!"
        else
            redirect_back fallback_location: root_path, notice: "likes!"
        end
    end
    def destroy
        @like = current_user.buyer.likes.find(params[:id])
        @like.destroy
        redirect_back fallback_location: root_path, notice: "unliked!"
    end
    def index
        @likes= current_user.buyer.likes.where(likeable_type: 'Item')

        @liked_items = @likes.map(&:likeable).compact.uniq
    end


end
