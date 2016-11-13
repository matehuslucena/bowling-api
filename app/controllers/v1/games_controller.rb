class V1::GamesController < ApplicationController
  include ActionController::Serialization

  before_action :set_game, only: [:update, :show]

  def create
    game = Game.create

    render json: game
  end

  def update
    @game.check_played(params[:knocked_pins].to_i)

    render json: @game
  end

  def show
    render json: @game
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
