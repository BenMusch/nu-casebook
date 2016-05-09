class AddVisibilityLevelToCases < ActiveRecord::Migration
  def change
    add_column :cases, :visibility, :integer, default: 1
    add_reference :cases, :user, index: true
  end
end
