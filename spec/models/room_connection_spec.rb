# == Schema Information
#
# Table name: room_connections
#
#  id             :integer          not null, primary key
#  source_room_id :integer          not null
#  target_room_id :integer          not null
#  direction      :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# spec/models/room_connection_spec.rb
require 'rails_helper'

RSpec.describe RoomConnection, type: :model do
  describe 'associations' do
    it { should belong_to(:source_room).class_name('Room') }
    it { should belong_to(:target_room).class_name('Room') }
  end

  describe 'validations' do
    it { should validate_presence_of(:direction) }
    it { should validate_inclusion_of(:direction).in_array(%w(north south east west)) }
  end

  describe 'custom validations' do
    let(:soork) { create(:soork) }
    let(:source_room) { create(:room, soork: soork) }
    let(:target_room) { create(:room, soork: soork) }
    let(:other_soork) { create(:soork) }
    let(:other_room) { create(:room, soork: other_soork) }

    context 'rooms from same soork' do
      subject { build(:room_connection, source_room: source_room, target_room: target_room, direction: 'north') }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'rooms from different soorks' do
      subject { build(:room_connection, source_room: source_room, target_room: other_room, direction: 'north') }

      it 'is invalid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:base]).to include("Rooms must belong to the same game")
      end
    end

    context 'duplicate directions' do
      it 'prevents duplicate directions from same source room' do
        create(:room_connection, source_room: source_room, target_room: target_room, direction: 'north')
        duplicate = build(:room_connection, source_room: source_room, direction: 'north')

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:base]).to include("Room already has a connection in that direction")
      end

      it 'allows same direction from different source rooms' do
        create(:room_connection, source_room: source_room, target_room: target_room, direction: 'north')
        different_source = create(:room, soork: soork)
        new_connection = build(:room_connection, source_room: different_source, target_room: target_room, direction: 'north')

        expect(new_connection).to be_valid
      end
    end
  end
end
