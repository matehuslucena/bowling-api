class CreateFrames < ActiveRecord::Migration[5.0]
  def change
    create_table :frames do |t|
      t.integer :total_score, default: 0
      t.references :game

      t.timestamps
    end
  end
end
