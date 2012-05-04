class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.integer :person_id
      t.string :session_token
      t.string :password_digest
      t.boolean :email_validated, default: false
      t.boolean :admin_approved, default: true
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :session_token
  end
end
