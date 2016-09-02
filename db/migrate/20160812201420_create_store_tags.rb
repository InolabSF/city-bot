class CreateStoreTags < ActiveRecord::Migration
  def change
    create_table :store_tags do |t|
      t.integer :tag_id
      t.integer :store_id
      t.string :value

      t.timestamps null: false
    end
  end
end
