require 'rails_helper'

RSpec.describe "Users", type: :request do
    let(:user) {create(:user)}
    let(:application) { create(:oauth_application) }
    let(:token) do 
        user.reload 
        Doorkeeper::AccessToken.create!(
            resource_owner_id: user.id, 
            application_id: application.id, 
            scopes: "public"
        ).token 
    end

    let(:headers) { {"Authorization" => "Bearer #{token}"}}

    describe "GET api/v1/users" do
        it "return all users" do
            get api_v1_users_path,headers: headers
            expect(response).to have_http_status(:ok)
        end
    end
end

