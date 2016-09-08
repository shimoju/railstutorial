class CreateListMembers < ActiveRecord::Migration
  def change
    create_table :list_members do |t|
      t.references :user, index: true, foreign_key: true
      t.references :list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
