require "rails_helper"

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #about" do
    it "should get about" do
      get :about
      expect(response).to be_successful
    end
  end
end