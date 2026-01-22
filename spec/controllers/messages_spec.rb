require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  render_views
  
  let(:user) { create(:user) }
  let(:conversation) { create(:conversation) }
  let(:valid_params) { { body: "Hello, is this item available?" } }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new message" do
        expect {
          post :create, params: { conversation_id: conversation.id, message: valid_params }
        }.to change(Message, :count).by(1)
      end

      it "assigns the current user to the message" do
        post :create, params: { conversation_id: conversation.id, message: valid_params }
        expect(Message.last.user).to eq(user)
      end

      it "redirects to the conversation" do
        post :create, params: { conversation_id: conversation.id, message: valid_params }
        expect(response).to redirect_to(conversation)
      end

      it "sets the message body correctly" do
        post :create, params: { conversation_id: conversation.id, message: valid_params }
        expect(Message.last.body).to eq(valid_params[:body])
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { body: "" } }

      it "does not create a message when body is empty" do
        expect {
          post :create, params: { conversation_id: conversation.id, message: invalid_params }
        }.not_to change(Message, :count)
      end
    end

    context "with non-existent conversation" do
      it "raises an error when conversation is not found" do
        expect {
          post :create, params: { conversation_id: 99999, message: valid_params }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end