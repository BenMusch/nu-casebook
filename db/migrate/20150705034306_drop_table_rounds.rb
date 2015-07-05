class DropTableRounds < ActiveRecord::Migration
  def change
    drop_table :rounds
  end
end
