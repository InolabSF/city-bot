class CreateNavigationContexts < ActiveRecord::Migration
  def change
    create_table :navigation_contexts do |t|
      t.integer :navigation_id
      t.integer :context_id
      t.string :value

      t.timestamps null: false
    end
  end
end
