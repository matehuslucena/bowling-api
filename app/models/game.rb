class Game < ApplicationRecord
  has_many :frames

  after_create :start_game

  def roll(knocked_pins)
    raise if get_current_frame.nil?

    current_frame = get_current_frame

    current_frame.throw_count += 1
    current_frame.join_score(knocked_pins) if current_frame.throw_count <= 3

    join_total_score knocked_pins

    if current_frame.throw_count == 2 && current_frame.score < 10
      current_frame.update(is_active: false)
      next_frame(current_frame).update(is_active: true) unless is_finished? current_frame
    end

    if current_frame.throw_count == 3
      current_frame.update(is_active: false)
      next_frame(current_frame).update(is_active: true) unless is_finished? current_frame

      return
    end

    if is_strike? current_frame
      current_frame.update(result: 'strike')

      return
    end

    if is_spare? current_frame
      current_frame.update(result: 'spare')

      unless is_finished? current_frame
        current_frame.update(is_active: false)
        next_frame(current_frame).update(is_active: true)
      end

      return
    end
  end

  def is_finished? current_frame
    next_frame(current_frame).nil?
  end

  private

  def join_total_score knocked_pins
    self.total_score += knocked_pins
    self.save
  end

  def get_current_frame
    self.frames.select{ |item| item.is_active == true }.first
  end

  def next_frame(current_frame)
    self.frames.each_with_index do |item, index|
      return self.frames[index+1] if item.id == current_frame.id
    end
  end

  def is_strike?(current_frame)
    current_frame.score == 10 && current_frame.throw_count == 1
  end

  def is_spare?(current_frame)
    current_frame.throw_count == 2 && current_frame.score == 10 && current_frame.result.nil?
  end

  def start_game
    self.frames << Frame.create(is_active: true)
    9.times{ self.frames << Frame.new }
    self.save
  end
end
