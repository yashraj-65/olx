require 'rails_helper'

class StubController < Api::V1::BaseController
  def index
    render json: { message: "Success", user_id: current_user&.id }
  end

  def show
    raise ActiveRecord::RecordNotFound, "Couldn't find Resource with 'id'=#{params[:id]}"
  end
end

RSpec.describe Api::V1::BaseController, type: :request do
  before do

    Rails.application.routes.draw do
      get 'stub' => 'stub#index'
      get 'stub/:id' => 'stub#show'
    end
  end

  after { Rails.application.reload_routes! }

  let(:user) { create(:user) }
  let(:application) { create(:oauth_application) }
 let(:token) do 
  Doorkeeper::AccessToken.create!(
    resource_owner_id: user.id, 
    application_id: application.id, 
    scopes: "public" 
  ).token 
end

  describe "Authentication" do
    it "returns 401 Unauthorized when no token is provided" do
      get '/stub'
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 200 and identifies current_user with valid token" do
      get '/stub', headers: { "Authorization" => "Bearer #{token}" }
      
      expect(response).to have_http_status(:ok)
    end
  end

  describe "Error Handling (rescue_from)" do
    it "returns 404 Not Found for ActiveRecord::RecordNotFound" do
      get '/stub/999', headers: { "Authorization" => "Bearer #{token}" }
      
      expect(response).to have_http_status(:not_found)

    end
  end
  describe "Polymorphic Authentication" do
  let(:admin) { create(:admin_user) } 
  let(:application) { create(:oauth_application) }
  
  let(:admin_token) do 
    Doorkeeper::AccessToken.create!(
      resource_owner_id: admin.id,
      resource_owner_type: 'AdminUser', 
      application_id: application.id, 
      scopes: "public" 
    ).token 
  end

  it "identifies current_user as an AdminUser" do
    get '/stub', headers: { "Authorization" => "Bearer #{admin_token}" }
    
    expect(response).to have_http_status(:ok)

  end
end
end