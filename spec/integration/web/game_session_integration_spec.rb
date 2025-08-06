# spec/integration/web/game_session_integration_spec.rb
require 'rails_helper'

RSpec.describe "Web::GameSession Integration", type: :model do
  let(:user) { create(:user) }
  let(:soork) { create(:web_soork, user: user) }
  
  let!(:entrance) { create(:web_area, :start_area, soork: soork, name: "Entrance") }
  let!(:hall) { create(:web_area, soork: soork, name: "Hall") }
  let!(:study) { create(:web_area, soork: soork, name: "Study") }
  
  let!(:north_connection) { create(:web_area_connection, source_area: entrance, target_area: hall, direction: 'north') }
  let!(:south_connection) { create(:web_area_connection, source_area: hall, target_area: entrance, direction: 'south') }
  let!(:east_connection) { create(:web_area_connection, source_area: hall, target_area: study, direction: 'east') }
  
  let!(:item) { create(:web_item, soork: soork, area: entrance, name: "Magic Key") }
  
  let(:game_session) { create(:web_game_session, user: user, soork: soork, current_area: entrance) }

  describe "complete game flow" do
    it "allows player to navigate and interact with the world" do
      # Start at entrance
      expect(game_session.current_area.name).to eq("Entrance")
      expect(game_session.current_area.items.any? {|item| item.name == "Magic Key"}).to be true

      # Check available exits
      exits = game_session.available_exits
      expect(exits[:north]).to eq(hall)
      expect(exits[:south]).to be_nil
      
      # Move north
      expect(game_session.move_to_area('north')).to be true
      expect(game_session.current_area.name).to eq("Hall")
      
      # Check new exits
      exits = game_session.available_exits
      expect(exits[:south]).to eq(entrance)
      expect(exits[:east]).to eq(study)
      expect(exits[:north]).to be_nil
      
      # Move east
      expect(game_session.move_to_area('east')).to be true
      expect(game_session.current_area.name).to eq("Study")
      
      # Try invalid direction
      expect(game_session.move_to_area('north')).to be false
      expect(game_session.current_area.name).to eq("Study")
    end
    
    it "correctly validates area belongs to soork" do
      other_soork = create(:web_soork)
      other_area = create(:web_area, soork: other_soork)
      
      game_session.current_area = other_area
      expect(game_session).not_to be_valid
      expect(game_session.errors[:current_area]).to include("must belong to the same Soork as the game session")
    end
  end
end