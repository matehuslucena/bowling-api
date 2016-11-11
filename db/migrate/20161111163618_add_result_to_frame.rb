class AddResultToFrame < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :result, :string
  end
end
