class Bowling
  def self.roll!(game, knocked_pins)
    raise if get_current_frame(game).nil?

    current_frame = get_current_frame game

    current_frame.throw_count += 1
    current_frame.increment_score(knocked_pins) if current_frame.throw_count <= 3

    increment_total_score game, knocked_pins

    if current_frame.throw_count == 2 && current_frame.score < 10
      current_frame.finalize
      activate_next_frame(game, current_frame) unless is_finished? game, current_frame
    end

    if current_frame.throw_count == 3
      current_frame.finalize
      activate_next_frame(game, current_frame) unless is_finished? game, current_frame

      return
    end

    if is_strike? current_frame
      current_frame.set_strike

      return
    end

    if is_spare? current_frame
      current_frame.set_spare

      unless is_finished? game, current_frame
        current_frame.finalize
        activate_next_frame(game, current_frame)
      end

      return
    end
  end


  private

  def self.is_finished? game, current_frame
    next_frame(game, current_frame).nil?
  end

  def self.increment_total_score game, knocked_pins
    game.total_score += knocked_pins
    game.save
  end

  def self.get_current_frame game
    game.frames.select{ |item| item.is_active == true }.first
  end

  def self.next_frame game, current_frame
    game.frames.each_with_index do |item, index|
      return game.frames[index+1] if item.id == current_frame.id
    end
  end

  def self.activate_next_frame game, current_frame
    next_frame(game, current_frame).update(is_active: true)
  end

  def self.is_strike?(current_frame)
    current_frame.score == 10 && current_frame.throw_count == 1
  end

  def self.is_spare?(current_frame)
    current_frame.throw_count == 2 && current_frame.score == 10 && current_frame.result.nil?
  end
end
