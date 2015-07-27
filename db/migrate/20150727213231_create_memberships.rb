class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :round, index: true, foreign_key: true
      t.belongs_to :member, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
