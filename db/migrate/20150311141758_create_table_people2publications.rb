class CreateTablePeople2publications < ActiveRecord::Migration
  def change
    create_table :people2publications do |t|
      t.integer "publication_id"
      t.integer "person_id"
      t.text "department_name"
      t.integer "position"
    end
  end
end
