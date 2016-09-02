class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :image_uri
      t.string :name
      t.string :opening_hour
      t.string :phone_number
      t.string :category
      t.string :address
      t.float :lat
      t.float :lng
      t.string :description

      t.timestamps null: false
    end
  end
end
