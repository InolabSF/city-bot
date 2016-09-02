class CreateCustomerValues < ActiveRecord::Migration
  def change
    create_table :customer_values do |t|
      t.string :name
      t.integer :operation_id
      t.integer :recency
      t.integer :frequency
      t.integer :satisfaction
      t.string :strategy

      t.timestamps null: false
    end
  end
end
