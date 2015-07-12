class ImplementTightCalls < ActiveRecord::Migration
  def change
    add_column :rounds, :tight_call, :boolean, default: false
    add_column :cases, :tight_call_losses, :integer, default: 0
    add_column :cases, :tight_call_wins, :integer, default: 0
  end
end
