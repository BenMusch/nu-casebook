class AddTightCallStatsToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :min_tight_call, :integer
    add_column :searches, :max_tight_call, :integer
  end
end
