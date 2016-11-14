class Frame < ApplicationRecord
  def increment_score knocked_pins
    self.score += knocked_pins
    self.save
  end

  def finalize
    self.update(is_active: false)
  end

  def set_strike
    self.update(result: 'strike')
  end

  def set_spare
    self.update(result: 'spare')
  end
end
