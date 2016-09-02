class CreateNavigations < ActiveRecord::Migration
  def change
    create_table :navigations do |t|
      # facebook
      t.string :locale
      t.integer :timezone
      t.string :gender
      t.string :first_name
      t.string :last_name

      # sender
      t.integer :sender_id

      t.string :navigation_type
      t.integer :destination_store_id
      t.string :recommendations

      t.integer :arrived

      t.timestamps null: false
    end
  end
end
