class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.text :title
      t.text :author
      t.integer :pubyear
      t.text :abstract

      t.timestamps
    end
  end
end
