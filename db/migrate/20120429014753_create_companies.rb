class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :street_address
      t.string :city_state_zip
      t.string :state_of_incorporation
      t.string :phone
      t.string :fax
      t.string :business_description

      t.timestamps
    end
  end
end
