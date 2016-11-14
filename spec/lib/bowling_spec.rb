require 'rails_helper'

RSpec.describe Bowling do
  describe '.roll!' do
    context 'when roll! is calling with correct parameters' do
      let(:game){ create :game }
      let(:strike){ Bowling.roll!(game, 10) }

      it 'must set strike' do
        strike

        expect(game.frames.first.result).to eq 'strike'
      end

      it 'must set spare' do
        2.times { Bowling.roll!(game, 5) }

        expect(game.frames.first.result).to eq 'spare'
      end

      context 'when have a strike' do
        it 'must be a 2 plus throws on the same frame' do
          strike

          2.times{ Bowling.roll!(game, 5) }

          expect(game.frames.first.score).to eq 20
        end
      end

      context 'when have a spare on the last frame' do
        it 'must be a 1 plus throw' do
          20.times{ Bowling.roll!(game, 5) }

          Bowling.roll!(game, 1)

          expect(game.frames.last.score).to eq 11
        end
      end

      context 'when all throw is a strike' do
        it 'must be calculate the correct plus throws' do
          30.times{ Bowling.roll!(game, 10) }

          expect(game.total_score).to eq 300
        end
      end

      context 'when all frames were played' do
        it 'must be raise a exception' do
          21.times{ Bowling.roll!(game, 5) }

          expect{Bowling.roll!(game, 5)}.to raise_error(RuntimeError)
        end
      end

      context 'when not have more throws for the frame' do
        it 'the next must be activate' do
          2.times{ Bowling.roll!(game, 4) }

          expect(game.frames.second.is_active).to be_truthy
        end
      end
    end
  end
end
