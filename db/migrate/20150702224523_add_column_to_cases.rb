class AddColumnToCases < ActiveRecord::Migration
  def change
    add_column :cases, :link, :text, default: "http://www.broken.com";
  end
end
