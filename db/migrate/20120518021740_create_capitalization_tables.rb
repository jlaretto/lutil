class CreateCapitalizationTables < ActiveRecord::Migration
  def change
    create_table :capitalization_tables do |t|
      t.integer :company_id
      t.string :description
      t.boolean :actual             #Pro Form or Real

      t.timestamps
    end
  end
end
