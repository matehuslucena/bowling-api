class AddThrowCountToFrame < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :throw_count, :integer, default: 0
  end
end
