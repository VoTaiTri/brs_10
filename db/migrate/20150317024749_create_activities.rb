class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :target_id
      t.string :action_type
      t.string :message
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :activities, :users
    add_index :activities, [:user_id, :created_at]
  end
end
