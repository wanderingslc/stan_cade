# spec/models/soork_player_spec.rb
require 'rails_helper'

RSpec.describe SoorkPlayer, type: :model do
  describe 'basic creation' do
    it 'can be created with defaults' do
      soork = create(:soork)
      room = create(:room, soork: soork)
      player = SoorkPlayer.create!(
        soork: soork,
        current_room: room,
        game_state_flags: {},
      )
      expect(player).to be_valid
    end
  end
  describe 'associations' do
    it { should belong_to(:soork) }
    it { should belong_to(:user).optional }
    it { should belong_to(:current_room).class_name('Room') }
  end

  describe 'validations' do
    subject { build(:soork_player) }  # This will create with all required associations

    it { should belong_to(:soork) }
    it { should belong_to(:user).optional }
    it { should belong_to(:current_room).class_name('Room') }
    it { should have_many(:room_visits) }
    it { should have_many(:visited_rooms).through(:room_visits) }
  end


  describe 'login requirement validation' do
    let(:soork) { create(:soork) }
    let(:room) { create(:room, soork: soork) }
    let(:user) { create(:user) }

    it 'is valid without user when login not required' do
      player = build(:soork_player, soork: soork, current_room: room, requires_login: false)
      expect(player).to be_valid
    end

    it 'is invalid without user when login required' do
      player = build(:soork_player, soork: soork, current_room: room, requires_login: true)
      expect(player).not_to be_valid
      expect(player.errors[:user]).to include("Logging in is required for this Soork")
    end

    it 'is valid with user when login required' do
      player = build(:soork_player, soork: soork, current_room: room, requires_login: true, user: user)
      expect(player).to be_valid
    end
  end

  describe 'states' do
    let(:player) { create(:soork_player) }

    it 'starts in active state' do
      expect(player.state).to eq('active')
    end

    it 'can transition from active to dead' do
      expect(player.die).to be true
      expect(player.state).to eq('dead')
    end

    it 'can transition from active to won' do
      expect(player.win).to be true
      expect(player.state).to eq('won')
    end

    it 'can transition from active to paused' do
      expect(player.pause).to be true
      expect(player.state).to eq('paused')
    end

    it 'can transition from paused to active' do
      player.state = 'paused'
      expect(player.resume).to be true
      expect(player.state).to eq('active')
    end
  end

  describe 'methods' do
    let(:soork) { create(:soork) }
    let(:room) { create(:room, soork: soork) }
    let(:player) { create(:soork_player, soork: soork, current_room: room) }
    let(:item) { create(:item, room: room) }

    describe '#visit_room' do
      let(:soork) { create(:soork)}
      let(:new_room) { create(:room, soork: soork) }

      it 'creates a new room visit' do
        expect {
          player.visit_room(new_room)
        }.to change { player.visited_rooms.count }.by(1)
      end

      it 'updates current room' do
        player.visit_room(new_room)
        expect(player.current_room).to eq(new_room)
      end

      it 'does not add duplicate room visits' do
        expect {
          2.times {player.visit_room(room)}
        }.to change {player.room_visits.count}.by(1)
        expect(player.times_visited(room)).to eq(2)
      end
    end

    describe '#inventory management' do
      it 'can pick up an item' do
        expect {
          player.pick_up_item(item)
        }.to change { player.player_items.count }.by(1)
      end

      it 'cannot pick up non-pickable items' do
        non_pickable_item = create(:item, room: room, is_pickable: false)
        expect(player.pick_up_item(non_pickable_item)).to be false
      end

      it 'can drop an item' do
        player.pick_up_item(item)
        expect {
          player.drop_item(item)
        }.to change { player.player_items.count }.by(-1)
      end

      it 'can check if it has an item' do
        player.pick_up_item(item)
        expect(player.has_item?(item)).to be true
      end
    end

    describe '#game flags' do
      it 'can set and get flags' do
        player.set_flag('solved_puzzle', true)
        expect(player.get_flag('solved_puzzle')).to be true
      end
    end
  end
end