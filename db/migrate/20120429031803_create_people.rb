class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.string :entityname
      t.string :type
      t.string :streetaddress
      t.string :city_state_zip
      t.string :country
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
