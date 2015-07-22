class AddSideToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :side_id, :integer
    add_index :rounds, :side_id
  end
end
