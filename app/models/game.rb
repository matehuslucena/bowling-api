class Game < ApplicationRecord
  has_many :frames

  after_create :start_game

  def start_game
    self.frames << Frame.create(is_active: true)
    9.times{ self.frames << Frame.new }
    self.save
  end
end
