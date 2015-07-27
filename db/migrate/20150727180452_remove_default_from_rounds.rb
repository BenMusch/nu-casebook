class RemoveDefaultFromRounds < ActiveRecord::Migration
  def change
    change_column_default :rounds, :speaks, nil
  end
end
