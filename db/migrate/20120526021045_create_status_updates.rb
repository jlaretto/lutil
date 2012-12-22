class CreateStatusUpdates < ActiveRecord::Migration
  def change
    create_table :status_updates do |t|
      t.integer :company_id, :null => false
      t.integer :user_id
      t.string :description
      t.string :related_objects

      t.timestamps
    end
    add_foreign_key(:status_updates, :companies)
  end
end
