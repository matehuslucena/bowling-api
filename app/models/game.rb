class Game < ApplicationRecord
  has_many :frames

  after_create :start

  private
  
  def start
    10.times{ self.frames << Frame.new }

    self.save
  end
end
