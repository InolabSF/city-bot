class CreateSenders < ActiveRecord::Migration
  def change
    create_table :senders do |t|
      t.string :facebook_id
      t.integer :navigation_id
      t.integer :customer_value_id

      t.timestamps null: false
    end
  end
end
