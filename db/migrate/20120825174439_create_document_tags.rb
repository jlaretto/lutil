class CreateDocumentTags < ActiveRecord::Migration
  def change
    create_table :document_tags do |t|
      t.integer :document_tag_type_id
      t.integer :document_id
      t.timestamps
    end
  end
end
