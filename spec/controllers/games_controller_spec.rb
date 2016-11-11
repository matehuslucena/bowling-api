require 'rails_helper'

RSpec.describe V1::GamesController, type: :controller do
  describe '#POST create' do
    subject {post :create}

    it { is_expected.to be_ok }

    it 'must be 10 frames' do
      expect(subject.body.frames.size).to eq? 10
    end
  end
end
