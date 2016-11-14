require 'rails_helper'

RSpec.describe V1::GamesController, type: :controller do

  describe '#POST create' do
    subject { post :create }

    it { is_expected.to be_ok }

    it 'must be return 10 frames' do
      body = JSON.parse(subject.body)

      expect(body['data']['attributes']['frames'].size == 10).to be_truthy
    end
  end

  describe '#PUT update' do
    subject { put :update, parameters }

    let(:game_strike){ create :game }

    let(:parameters){ { params: { id: game_strike.id, knocked_pins: pins_quantity } } }

    context 'when one throw knocked down 10 pins' do
      let(:pins_quantity){ 10 }

      it 'must be a strike' do
        body = JSON.parse(subject.body)
        frame = body['data']['attributes']['frames'].first

        expect(frame['result']).to eq 'strike'
      end

      context 'if is strike plus 2 throws' do
        let(:pins_quantity){ 3 }

        it 'must be sum previous point and extra throw point' do
          game_strike.frames.first.update(score: 10, throw_count: 1, result: 'strike', is_active: true)

          body = JSON.parse(subject.body)
          frame = body['data']['attributes']['frames'].first

          expect(frame['score']).to eq 13
        end

        it 'when 2 plus throws end must be desactivate current frame and active next' do
          game_strike.frames.first.update(score: 20, throw_count: 2, result: 'strike', is_active: true)

          body = JSON.parse(subject.body)
          frame = body['data']['attributes']['frames'].second

          expect(frame['is_active']).to eq true
        end
      end
    end

    context 'when knocked down 10 pins with two throws' do
      let(:game_spare){ create :game }

      let(:parameters){ { params: { id: game_spare.id, knocked_pins: 9 } } }

      it 'must be a spare' do
        game_spare.frames.first.update(score: 1, throw_count: 1)

        body = JSON.parse(subject.body)
        frame = body['data']['attributes']['frames'].first

        expect(frame['result']).to eq 'spare'
      end
    end

    context 'when have strike in all frames' do
      let(:all_strike_game){ create :game }

      let(:parameters){ { params: { id: all_strike_game.id, knocked_pins: 10 } } }

      before(:each) do
        30.times do
          put :update, parameters
        end
      end

      it 'must be sum correctly' do
        expect(Game.find(all_strike_game.id).total_score == 300).to be_truthy
      end

      it 'must be game over' do
        subject { put :update, id: all_strike_game, knocked_pins: 1 }

        msg = JSON.parse(subject.body)

        expect(msg['error']).to eq I18n.t('.message.error.game_over')
      end
    end

    context 'when have spare on the last frame' do
      let(:spare_last_frame_game){ create :game }

      let(:parameters){ { params: { id: spare_last_frame_game.id, knocked_pins: 5 } } }

      context 'must be a extra throw' do
        before(:each) do
          20.times do
            put :update, parameters
          end

          put :update, params: { id: spare_last_frame_game, knocked_pins: 1 }
        end

        it 'must compute the last extra throw' do
          expect(Game.find(spare_last_frame_game.id).total_score == 101).to be_truthy
        end

        it 'must be game over after the last throw' do
          msg = JSON.parse(subject.body)

          expect(msg['error']).to eq I18n.t('.message.error.game_over')
        end
      end
    end
  end

  describe '#GET show' do
    let(:game){ create :game }

    subject { get :show, params: { id: game.id } }

    it{ is_expected.to be_success }

    it 'must get the game' do
      game = JSON.parse(subject.body)

      expect(game['data']['attributes']['frames'].size == 10).to be_truthy
    end
  end
end
