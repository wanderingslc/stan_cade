# spec/integration/soork_gameplay_spec.rb
require 'rails_helper'

RSpec.describe "Soork Gameplay", type: :model do
  describe 'simple adventure playthrough' do
    let(:user) { create(:user) }
    let(:soork) { create(:soork, user: user) }

    # Create a simple three-room adventure:
    # Starting Room -> Hallway -> Treasure Room
    let(:start_room) { create(:room, :start_room, soork: soork, name: "Starting Room",
                              description: "A dimly lit room with stone walls.") }
    let(:hallway) { create(:room, soork: soork, name: "Hallway",
                           description: "A long, dark hallway stretches before you.") }
    let(:treasure_room) { create(:room, soork: soork, name: "Treasure Room",
                                 description: "A glittering room full of treasures!") }

    # Create a key item needed to access the treasure room
    let(:rusty_key) { create(:item, room: start_room, name: "Rusty Key",
                             description: "An old rusty key.",
                             properties: { unlocks: "treasure_room" }) }

    let(:player) { create(:soork_player, soork: soork, current_room: start_room) }

    before do
      # Connect rooms
      create(:room_connection, source_room: start_room, target_room: hallway, direction: 'north')
      create(:room_connection, source_room: hallway, target_room: treasure_room, direction: 'north')
    end

    it 'allows player to navigate and interact' do
      # Check initial state
      expect(player.current_room).to eq(start_room)
      expect(player.times_visited(start_room)).to eq(0)

      # Visit starting room
      player.visit_room(start_room)
      expect(player.times_visited(start_room)).to eq(1)

      # Pick up the key
      player.pick_up_item(rusty_key)
      expect(player.player_items).to include(have_attributes(item: rusty_key))

      # Move to hallway
      player.visit_room(hallway)
      expect(player.current_room).to eq(hallway)
      expect(player.times_visited(hallway)).to eq(1)

      # Move to treasure room
      player.visit_room(treasure_room)
      expect(player.current_room).to eq(treasure_room)
      expect(player.times_visited(treasure_room)).to eq(1)

      # Track game progress
      player.game_state_flags['treasure_room_visited'] = true
      player.save
      expect(player.game_state_flags['treasure_room_visited']).to be true
    end

    it 'tracks room visit counts correctly' do
      3.times { player.visit_room(start_room) }
      expect(player.times_visited(start_room)).to eq(3)
    end

    it 'maintains inventory across rooms' do
      player.pick_up_item(rusty_key)
      player.visit_room(hallway)
      player.visit_room(treasure_room)
      expect(player.player_items.map(&:item)).to include(rusty_key)
    end
  end
end
