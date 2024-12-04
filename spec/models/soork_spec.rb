# spec/models/soork_spec.rb
require 'rails_helper'

RSpec.describe Soork, type: :model do
  describe 'associations' do
    it { should have_many(:rooms) }
    it { should have_many(:items).through(:rooms) }
  end

  describe 'dependency' do
    it 'destroys associated rooms' do
      soork = create(:soork)
      room = create(:room, soork: soork)
      expect { soork.destroy }.to change { Room.count }.by(-1)
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'states' do
    let(:soork) { create(:soork) }

    it 'starts in draft state' do
      expect(soork.state).to eq('draft')
    end

    it 'can transition from draft to testing' do
      expect(soork.begin_testing).to be true
      expect(soork.state).to eq('testing')
    end

    it 'can transition from testing to published' do
      soork.state = 'testing'
      expect(soork.publish).to be true
      expect(soork.state).to eq('published')
    end

    it 'can transition from published to archived' do
      soork.state = 'published'
      expect(soork.archive).to be true
      expect(soork.state).to eq('archived')
    end
  end
end