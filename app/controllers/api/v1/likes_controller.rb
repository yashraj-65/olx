module Api
    module V1
        class LikesController < BaseController
                before_action :doorkeeper_authorize!
            def index 
                @likes = Like.includes({buyer: :userable}, :likeable).all

            end
            def  create
                @like = Like.new(like_params)
                @like.buyer = current_user.buyer
                if @like.save
                    render json: {message: "succesfully created like", like: @like}, status: :ok
                else
                    render json: {errors: @like.errors.full_messages}, status: :unprocessable_entity
                end
            end


            def like_params
            params.require(:like).permit(:likeable_id, :likeable_type)
            end

        end
    end
end