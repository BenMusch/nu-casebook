class AddDefaultToRoundsWithSpeaks < ActiveRecord::Migration
  def change
    change_column_default :cases, :rounds_with_speaks, 0
  end
end
