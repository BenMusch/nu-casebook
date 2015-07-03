class AddOppChoiceToCases < ActiveRecord::Migration
  def change
    add_column :cases, :opp_choice, :boolean
  end
end
