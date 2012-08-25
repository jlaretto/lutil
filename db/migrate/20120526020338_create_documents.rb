class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :company_id
      t.string :description
      t.string :document_type
      t.string :name
      t.string :aws_key
      t.datetime :applicable_date

      t.timestamps
    end
  end
end
