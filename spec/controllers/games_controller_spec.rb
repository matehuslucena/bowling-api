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

    let!(:game_strike){ create :game }

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
  end
end
