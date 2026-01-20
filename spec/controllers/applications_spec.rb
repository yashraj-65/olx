require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # Create an anonymous controller to test inherited behavior
  controller do
    def index
      render json: { message: "success" }
    end
  end

  describe "Authentication Filter" do
    context "when request is NOT an admin request" do
      it "redirects to sign in if user is not authenticated" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end

      it "allows access if user is authenticated" do
        user = create(:user)
        sign_in user
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context "when request IS an admin request" do
      before do
        # Mock the admin_request? method to return true
        allow(controller).to receive(:admin_request?).and_return(true)
      end

      it "does not trigger authenticate_user!" do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "#admin_request?" do
    it "returns true if the path starts with /admin" do
      allow(request).to receive(:path).and_return('/admin/dashboard')
      expect(controller.send(:admin_request?)).to be true
    end

    it "returns false if the path does not start with /admin" do
      allow(request).to receive(:path).and_return('/home')
      expect(controller.send(:admin_request?)).to be false
    end
  end

  describe "Devise Parameter Sanitization" do
    it "configures permitted parameters for sign_up" do
      # Mock the devise_parameter_sanitizer
      sanitizer = double('sanitizer')
      allow(controller).to receive(:devise_parameter_sanitizer).and_return(sanitizer)
      
      # Assert that :name is permitted for :sign_up
      expect(sanitizer).to receive(:permit).with(:sign_up, keys: [:name])
      expect(sanitizer).to receive(:permit).with(:account_update, keys: [:name, :description, :avatar])
      
      controller.send(:configure_permitted_parameters)
    end
  end
end