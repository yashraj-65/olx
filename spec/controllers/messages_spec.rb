require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
    render_views
  let(:user) { create(:user) }
  let(:conversation) { create(:conversation) }

  before do
    sign_in user
  end

  describe "POST #create" do
    let(:valid_params) { { body: "Hello, is this item available?" } }

    context "with HTML format" do
      it "creates a message and redirects to the conversation" do
        expect {
          post :create, params: { conversation_id: conversation.id, message: valid_params }
        }.to change(Message, :count).by(1)

        expect(response).to redirect_to(conversation)
        expect(Message.last.user).to eq(user)
      end
    end

    context "using Doubles (Mocking)" do
      it "builds the message correctly" do
        mock_convo = instance_double(Conversation, id: 99)
        mock_messages = double("messages_relation")
        mock_message = instance_double(Message)

        allow(Conversation).to receive(:find).with("99").and_return(mock_convo)
        allow(mock_convo).to receive(:messages).and_return(mock_messages)

        expect(mock_messages).to receive(:build).with(hash_including(body: "Hi")).and_return(mock_message)
        expect(mock_message).to receive(:user=).with(user)
        expect(mock_message).to receive(:save).and_return(true)
        allow(mock_message).to receive(:conversation).and_return(mock_convo)
        allow(mock_convo).to receive(:to_model).and_return(mock_convo)
        allow(mock_convo).to receive(:persisted?).and_return(true)
        allow(mock_convo).to receive(:model_name).and_return(Conversation.model_name)

        post :create, params: { conversation_id: 99, message: { body: "Hi" } }
      end
    end
  end
end