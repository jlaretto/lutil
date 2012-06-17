class CreateStatusUpdates < ActiveRecord::Migration
  def change
    create_table :status_updates do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :description

      t.timestamps
    end
  end
end
