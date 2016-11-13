class V1::GamesController < ApplicationController
  include ActionController::Serialization

  before_action :set_game, only: [:update, :show]

  def create
    game = Game.create

    render json: game
  end

  def update
    return render json: { error: 'Pins quantity can not be bigger than 10' } if  knocked_pins > 10

    begin
      @game.roll(knocked_pins)

      render json: @game
    rescue
      render json: { error: 'Game is finished' }
    end
  end

  def show
    render json: @game
  end

  private

  def knocked_pins
    params[:knocked_pins].to_i
  end

  def set_game
    @game = Game.find(params[:id])
  end
end
