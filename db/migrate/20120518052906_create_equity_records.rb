class CreateEquityRecords < ActiveRecord::Migration
  def change
    create_table :equity_records do |t|

      t.integer :capitalization_record_id
      t.integer :person_id
      t.float :amount
      t.datetime :grant_date
      t.integer :vesting_schedule_id
      t.string :equity_type
      t.integer :relation_from_id
      t.string :relation_from_description
      t.integer :relation_to_id
      t.string :relation_to_description

      t.timestamps
    end
  end
end
