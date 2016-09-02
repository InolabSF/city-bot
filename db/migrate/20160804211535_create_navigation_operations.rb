class CreateNavigationOperations < ActiveRecord::Migration
  def change
    create_table :navigation_operations do |t|
      t.integer :navigation_id
      t.integer :operation_id
      t.datetime :time_to_execute

      t.timestamps null: false
    end
  end
end
