class MessagesController < ApplicationController

    def create
        @conversation = Conversation.find(params[:conversation_id])
        @message = @conversation.messages.build(message_params)
        
        @message.user = current_user

        if @message.save
            respond_to do |format|
                format.turbo_stream
                format.html {redirect_to @message.conversation}
            end
        end

    end

    def message_params
        params.require(:message).permit(:body)
    end




end
