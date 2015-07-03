class RemoveLinkFromCases < ActiveRecord::Migration
  def change
    remove_column :cases, :link, :string
  end
end
