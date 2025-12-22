    class LikesController < ApplicationController
        before_action :set_buyer
        def create
 
            @item = Item.find(params[:item_id])

            @like = @buyer.likes.find_or_initialize_by(likeable: @item)
            if @like.persisted?
                redirect_back fallback_location: root_path
            elsif @like.save
                redirect_back fallback_location: root_path, notice: "likes!"
            else

                redirect_back fallback_location: root_path, notice: "likes!"
            end
        end
        def like_review
          @review = Review.find(params[:id])
          @like = @buyer.likes.find_or_initialize_by(likeable: @review)
          if @like.persisted?
            redirect_back fallback_location: root_path
          elsif @like.save
            redirect_back fallback_location: root_path
          else
            redirect_back fallback_location: root_path
          end
        end
        def destroy
            @like = current_user.buyer.likes.find(params[:id])

            type = @like.likeable_type
            if @like.destroy
            redirect_back fallback_location: root_path, notice: "unliked!"
            end
        end
        def index
            @likes= current_user.buyer.likes.where(likeable_type: 'Item')

            @liked_items = @likes.map(&:likeable).compact.uniq
        end

        private 
        def set_buyer
            @buyer = current_user.buyer  || current_user.create_buyer
        end
    end
