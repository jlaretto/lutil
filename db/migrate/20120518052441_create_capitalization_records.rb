class CreateCapitalizationRecords < ActiveRecord::Migration
  def change
    create_table :capitalization_records do |t|
      t.integer :capitalization_table_id
      t.string :description
      t.float :authorized_amount

      t.timestamps
    end
  end
end
