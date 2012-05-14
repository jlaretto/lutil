class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :entity_name
      t.string :type
      t.string :street_address
      t.string :city_state_zip
      t.string :country
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
