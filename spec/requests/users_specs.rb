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
      it "return all specific user" do
            get api_v1_user_path(user),headers: headers
            expect(response).to have_http_status(:ok)
        end
    end

    describe "Creating a user" do
    let(:valid_params) do
      {
        user: {
          name: "Test User",
          email: "test@example.com",
          password: "Password123!", # Meets your regex requirements
          password_confirmation: "Password123!"
        }
      }
    end
        it "succefully created a user" do
            expect {
            post api_v1_users_path, params: valid_params
            }.to change(User, :count).by(1)

      
            expect(response).to have_http_status(:created)
        end
    end

   describe "Updating a user" do
        let(:other_user) { create(:user) }
        let(:edit_params) do
            {
                user: {
                name: " User",

                }
            }
            end
        context "authorized to update" do
            it "user updated succefully" do
                patch api_v1_user_path(user), headers: headers,params: edit_params

                expect(response).to have_http_status(:ok)
            end
        end
        context "not authoirzed to edit" do
            it "cant update user" do
                  patch api_v1_user_path(other_user), headers: headers,params: edit_params
                  expect(response).to have_http_status(:forbidden)
            end
        end
    end
end

