class MessagesController < ApplicationController

    def create
        @conversation = Conversation.find(params[:conversation_id])
        @message = @conversation.messages.build(message_params)
        
        @message.user = current_user

        if @message.save
            redirect_back fallback_location: conversation_path(@conversation)
        else
            redirect_back fallback_location: conversation_path(@conversation)  
        end

    end

    def message_params
        params.require(:message).permit(:body)
    end




end
