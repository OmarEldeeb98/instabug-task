require "rails_helper"

RSpec.describe "applications", type: :request do
  it "creates new application" do
    post "/applications", :params => {:name => "My test app"} 
    expect(response).to have_http_status(:created)
    expect(response.body).to include(I18n.t("application_created"))
  end
  it "creates new application without name" do
    post "/applications"
    expect(response).to have_http_status(:bad_request)
  end

  it "updates application name" do
    application = FactoryBot.create(:application)
    put "/applications/#{application.token}", :params => {:name => "My test app"} 
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(I18n.t("application_updated"))
  end

  it "updates application name without name" do
    application = FactoryBot.create(:application)
    put "/applications/#{application.token}"
    expect(response).to have_http_status(:bad_request)
  end

  it "updates application with invalid" do
    put "/applications/123456"
    expect(response).to have_http_status(:not_found)
  end

  it "shows application with invalid" do
    get "/applications/123456"
    expect(response).to have_http_status(:not_found)
  end

  it "shows application" do
    application = FactoryBot.create(:application)
    get "/applications/#{application.token}"
    expect(response).to have_http_status(:ok)
    expect(json['data']['name']).to eq(application.name)
  end

end