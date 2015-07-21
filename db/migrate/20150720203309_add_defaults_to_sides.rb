class AddDefaultsToSides < ActiveRecord::Migration
  def change
    change_column :sides, :wins, :integer, default: 0
    change_column :sides, :losses, :integer, default: 0
  end
end
