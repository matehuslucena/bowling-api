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
    let(:parameters){ { params: { id: game.id, knocked_pins: pins_quantity } } }

    subject { put :update, parameters }

    context 'when action is called with correct params' do
      let(:game){ create :game }
      let(:pins_quantity){ 10 }

      it 'must call method from lib' do
        allow(Bowling).to receive(:roll!).with(game, 10).and_return(game)

        expect(Bowling).to receive(:roll!)

        subject
      end
    end

    context 'when action is called with knocked pins bigger than 10' do
      let(:game){ create :game }
      let(:pins_quantity){ 11 }

      it 'must not call method from lib' do
        allow(Bowling).to receive(:roll!).with(game, 10).and_return(game)

        expect(Bowling).not_to receive(:roll!)

        subject
      end

      it 'must return error message' do
        message = JSON.parse(subject.body)

        expect(message['error']).to eq I18n.t('.message.error.wrong_pins_quantity')
      end
    end

    context 'when all frames are played' do
      let(:game){ create :game }
      let(:pins_quantity){ 5 }

      it 'must return game over message' do
        21.times do
          put :update, params:{ id: game.id, knocked_pins: 5 }
        end

        message = JSON.parse(subject.body)

        expect(message['error']).to eq I18n.t('.message.error.game_over')
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
