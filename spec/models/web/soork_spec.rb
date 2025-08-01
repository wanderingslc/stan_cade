require 'rails_helper'

RSpec.describe Web::Soork, type: :model do

  let (:soork) { build(:web_soork) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(soork).to be_valid
    end

    it 'is not valid without a title' do
      soork.title = nil
      expect(soork).not_to be_valid
    end

    it 'is not valid with an invalid state' do
      soork.state = 'invalid_state'
      expect(soork).not_to be_valid
    end

    it 'requires a user' do
      soork.user = nil
      expect(soork).not_to be_valid
    end
  end
  
  describe 'defaults' do
    it 'defaults to draft state' do
      expect(soork.state).to eq('draft')
    end

    it 'is not published by default' do
      expect(soork.published).to be_falsey
      expect(soork.published_at).to be_nil
    end
  end

  describe '#publish!' do
    it 'changes state to published' do
      soork.publish!
      expect(soork.state).to eq('published')
      expect(soork.published).to be_truthy
      expect(soork.published_at).to be_present
    end

    it 'updates published_at to current time' do
      previous_time = Time.current
      soork.publish!
      expect(soork.published_at).to be > previous_time
    end
  end

  describe 'scopes' do
    let (:user) { create(:user) }
    let!(:draft_soork) { create(:web_soork, user: user, state: 'draft', published: false) }
    let!(:published_soork) { create(:web_soork, user: user, state: 'published', published: true) }

    it '.published returns only published soorks' do
      expect(Web::Soork.published.count).to eq(1)
      expect(Web::Soork.published.first.state).to eq('published')
    end

    it '.by_user returns soorks for a specific user' do
      other_user = create(:user)
      create(:web_soork, user: other_user)
      expect(Web::Soork.by_user(user).count).to eq(2)
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:areas).dependent(:destroy) }
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:game_sessions).dependent(:destroy) }
  end
end