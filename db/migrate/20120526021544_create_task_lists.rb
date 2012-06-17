class CreateTaskLists < ActiveRecord::Migration
  def change
    create_table :task_lists do |t|
      t.string :description
      t.integer :company_id

      t.timestamps
    end
  end
end
