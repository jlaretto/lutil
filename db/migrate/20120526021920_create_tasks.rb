class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description
      t.string :type
      t.integer :responsible_user_id
      t.string :urgency
      t.string :instructions
      t.string :answer
      t.datetime :deadline
      t.datetime :last_ping
      t.datetime :next_ping
      t.integer :task_list_id

      t.timestamps
    end
  end
end
