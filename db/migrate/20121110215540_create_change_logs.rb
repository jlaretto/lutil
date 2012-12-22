class CreateChangeLogs < ActiveRecord::Migration
  def change
    create_table :change_logs do |t|
      t.integer :objid, :null => false

      t.string :objtype, :null => false
      t.string :objjson, :null => false

      t.integer :user_id, :null => false
      t.integer :company_id
      t.string :description

      t.timestamps
    end
  end
end
