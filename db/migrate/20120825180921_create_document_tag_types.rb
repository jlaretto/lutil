class CreateDocumentTagTypes < ActiveRecord::Migration
  def change
    create_table :document_tag_types do |t|
      t.string :name
      t.string :description
      t.string :mandatory_tags
      t.string :suggested_tags
      t.integer :type
      t.integer :company_id

      t.timestamps
    end
  end
end
