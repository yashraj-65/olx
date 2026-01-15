FactoryBot.define do
    factory :oauth_application, class: 'Doorkeeper::Application' do
    name { "Web" }
    redirect_uri { "https://localhost" }
    scopes { "public" }
  end
end