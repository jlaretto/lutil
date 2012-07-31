class CreateEquityRecords < ActiveRecord::Migration
  def change
    create_table :equity_records do |t|

      t.integer :capitalization_record_id
      #denormalized
      t.integer :company_id
      t.integer :person_id


      t.float :amount

      #for modeling purposes, stores the type of pro forma measurement
      #0 = not proforma
      #1 = proforma amount
      #2 = proforma percentage (issued and outstanding)
      #3 = proforma percentage (fully diluted)
      t.integer :proforma_target_amount_type, default: 0

      t.datetime :grant_date
      t.integer :vesting_schedule_id

      t.string :equity_type
      t.integer :equity_plan_id

      t.integer :relation_from_id
      t.string :relation_from_description
      t.integer :relation_to_id
      t.string :relation_to_description

      t.string :certificate_number
      t.integer :record_number

      t.timestamps
    end
  end
end
