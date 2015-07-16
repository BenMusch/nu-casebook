class AddMoreStatsToCases < ActiveRecord::Migration
  def change
    add_column :cases, :win_percentage, :float, default: 0.0
    add_column :cases, :tight_call_percentage, :float, default: 0.0
    add_column :cases, :tight_call_win_percentage, :float, default: 0.0
    add_column :cases, :average_speaks, :float, default: 0.0
  end
end
