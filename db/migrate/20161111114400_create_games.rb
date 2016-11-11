class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :total_score
      t.frame :references

      t.timestamps
    end
  end
end
