require 'rails_helper'

RSpec.describe Frame, type: :model do

  let(:game){ create :game }

  it 'the score must be increment' do
    game.frames.first.increment_score 10

    expect(game.frames.first.score).to eq 10
  end

  it 'the frame must be finalize' do
    game.frames.first.finalize

    expect(game.frames.first.is_active).to be_falsey
  end

  it 'the frame must be set with strike' do
    game.frames.first.set_strike

    expect(game.frames.first.result).to eq 'strike'
  end

  it 'the frame must be set with spare' do
    game.frames.first.set_spare

    expect(game.frames.first.result).to eq 'spare'
  end
end
