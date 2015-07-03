class AddCaseStatementToCases < ActiveRecord::Migration
  def change
    add_column :cases, :case_statement, :text
  end
end
