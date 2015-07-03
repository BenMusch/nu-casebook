class RemoveDefaultFromCases < ActiveRecord::Migration
  def change
    change_column_default :cases, :link, nil
  end
end
