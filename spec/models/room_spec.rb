# spec/models/room_spec.rb
require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'associations' do
    it { should belong_to(:soork) }
    it { should have_many(:items).dependent(:destroy) }

    # Directional connections
    it { should have_one(:north_connection) }
    it { should have_one(:south_connection) }
    it { should have_one(:east_connection) }
    it { should have_one(:west_connection) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:x) }
    it { should validate_presence_of(:y) }
    it { should validate_numericality_of(:x) }
    it { should validate_numericality_of(:y) }
  end

  describe 'start room validation' do
    let(:soork) { create(:soork) }

    it 'allows one start room per soork' do
      first_room = create(:room, soork: soork, start_room: true)
      expect(first_room).to be_valid
    end

    it 'prevents multiple start rooms per soork' do
      create(:room, soork: soork, start_room: true)
      second_start_room = build(:room, soork: soork, start_room: true)
      expect(second_start_room).not_to be_valid
      expect(second_start_room.errors[:start_room]).to include("Already exists for this Soork")
    end

    it 'allows start rooms for different soorks' do
      soork2 = create(:soork)
      room1 = create(:room, soork: soork, start_room: true)
      room2 = create(:room, soork: soork2, start_room: true)
      expect(room2).to be_valid
    end
  end

  describe 'states' do
    let(:room) { create(:room) }

    it 'starts in locked state' do
      expect(room.state).to eq('locked')
    end

    it 'can transition from locked to unlocked' do
      expect(room.unlock).to be true
      expect(room.state).to eq('unlocked')
    end

    it 'can transition from unlocked to hidden' do
      room.state = 'unlocked'
      expect(room.hide).to be true
      expect(room.state).to eq('hidden')
    end

    it 'can transition from hidden to visible' do
      room.state = 'hidden'
      expect(room.reveal).to be true
      expect(room.state).to eq('visible')
    end
  end

  describe 'room connections' do
    let(:soork) { create(:soork) }
    let(:room) { create(:room, :with_connection, soork: soork, direction: 'north') }

    it 'can connect to another room in a specified direction' do
      expect(room.north_connection).to be_present
      expect(room.south_connection).to be_nil
      expect(room.east_connection).to be_nil
      expect(room.west_connection).to be_nil
    end
  end
end