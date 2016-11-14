class V1::GamesController < ApplicationController
  include ActionController::Serialization

  before_action :set_game, only: [:update, :show]

  def create
    game = Game.create

    render json: game
  end

  def update
    return render json: { error: I18n.t('.message.error.wrong_pins_quantity') } if  knocked_pins > 10

    begin
      Bowling.roll! @game, knocked_pins

      render json: @game
    rescue
      render json: { error: I18n.t('.message.error.game_over') }
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
