require "rails_helper"

RSpec.describe GamesController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #faune" do
    it "should get faune" do
      get :faune
      expect(response).to be_successful
    end
  end

  describe "GET #rabbit_jump" do
    it "should get rabbit_jump" do
      get :rabbit_jump
      expect(response).to be_successful
    end
  end

  describe "GET #starfall" do
    it "should get starfall" do
      get :starfall
      expect(response).to be_successful
    end
  end
end
