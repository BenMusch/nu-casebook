class AddCaseToSides < ActiveRecord::Migration
  def change
    add_reference :sides, :case, index: true, foreign_key: true
  end
end
