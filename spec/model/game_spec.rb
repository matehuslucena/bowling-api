require 'rails_helper'

RSpec.describe Game, type: :model do

  context 'when start a new game' do
    let(:game) { create :game } 

    it 'must be add 10 frames' do
      expect(game.frames.size).to eq 10
    end

    it 'the first frame must be active' do
      expect(game.frames.first.is_active).to be_truthy
    end
  end
end
