class Frame < ApplicationRecord
  def join_score knocked_pins
    self.score += knocked_pins
    self.save
  end
end
