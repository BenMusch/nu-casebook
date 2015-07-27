class AddRoundsWithSpeaksToCases < ActiveRecord::Migration
  def change
    add_column :cases, :rounds_with_speaks, :integer
    update "UPDATE cases SET rounds_with_speaks = wins+losses"
  end
end
