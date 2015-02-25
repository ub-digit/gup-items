class CreatePublicationTypes < ActiveRecord::Migration
  def change
    create_table :publication_types do |t|
      t.text :publication_type_code
      t.text :content_type
      t.text :form_template
      t.timestamps
    end
  end
end
