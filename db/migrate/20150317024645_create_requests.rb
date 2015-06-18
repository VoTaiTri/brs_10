class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :book_name
      t.string :author
      t.string :book_url
      t.integer :state
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :requests, :users
  end
end
