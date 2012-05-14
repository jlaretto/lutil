class CreateRelationPersonCompanies < ActiveRecord::Migration
  def change
    create_table :relation_person_companies do |t|
      t.integer :person_id
      t.integer :company_id
      t.integer :relation_type
      t.string :relation_detail

      t.timestamps
    end
  end
end
