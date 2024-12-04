require 'rails_helper'

RSpec.describe RoomVisit, type: :model do
  describe 'associations' do
    it { should belong_to(:soork_player) }
    it { should belong_to(:room) }
  end

  describe 'validations' do
    it { should validate_presence_of(:visit_count) }
    it { should validate_presence_of(:last_visited_at) }
    it { should validate_numericality_of(:visit_count).is_greater_than_or_equal_to(0) }
  end

  describe 'visit tracking' do
    let(:soork) { create(:soork) }
    let(:room) { create(:room, soork: soork) }
    let(:player) { create(:soork_player, soork: soork, current_room: room) }
    let(:room_visit) { create(:room_visit, soork_player: player, room: room) }

    it 'tracks visit count' do
      expect(room_visit.visit_count).to eq(1)
    end

    it 'tracks last visited time' do
      expect(room_visit.last_visited_at).to be_present
    end
  end
end