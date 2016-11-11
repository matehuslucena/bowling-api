class V1::GamesController < ApplicationController
  include ActionController::Serialization

  def index
  end

  def create
    game = Game.create

    render json: game
  end
end
