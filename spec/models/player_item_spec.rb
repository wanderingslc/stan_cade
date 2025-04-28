# == Schema Information
#
# Table name: player_items
#
#  id                 :integer          not null, primary key
#  soork_player_id    :integer          not null
#  item_id            :integer          not null
#  uses_remaining     :integer
#  current_durability :integer
#  equipped           :boolean
#  acquired_at        :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

RSpec.describe PlayerItem, type: :model do
  describe 'associations' do
    it { should belong_to(:soork_player) }
    it { should belong_to(:item) }
  end

  describe 'validations' do
    subject(:player_item) do
      soork = create(:soork)
      room = create(:room, soork: soork)
      player = create(:soork_player, soork: soork, current_room: room)
      item = create(:item, room: room)
      build(:player_item, soork_player: player, item: item)
    end

    it { should validate_numericality_of(:uses_remaining).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:current_durability).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe 'item tracking' do
    let(:soork) { create(:soork) }
    let(:room) { create(:room, soork: soork) }
    let(:player) { create(:soork_player, soork: soork, current_room: room) }
    let(:item) { create(:item, room: room) }
    let(:player_item) { create(:player_item, soork_player: player, item: item) }

    it 'tracks uses remaining' do
      expect(player_item.uses_remaining).to eq(3)  # From factory default
    end

    it 'tracks durability' do
      expect(player_item.current_durability).to eq(100)  # From factory default
    end

    it 'tracks equipped status' do
      expect(player_item).not_to be_equipped
      player_item.update(equipped: true)
      expect(player_item).to be_equipped
    end

    it 'tracks acquisition time' do
      expect(player_item.acquired_at).to be_present
    end
  end
end
