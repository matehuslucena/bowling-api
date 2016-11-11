class AddIsActiveFrame < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :is_active, :boolean, default: false
  end
end
