class AddStatsToCase < ActiveRecord::Migration
  def change
    add_column :cases, :wins, :integer, default: 0
    add_column :cases, :losses, :integer, default: 0
    add_column :cases, :speaks, :float, default: 0
  end
end
