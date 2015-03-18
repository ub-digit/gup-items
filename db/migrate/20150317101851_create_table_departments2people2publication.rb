class CreateTableDepartments2people2publication < ActiveRecord::Migration
  def change
    create_table :departments2people2publications do |t|
      t.integer "people2publication_id"
      t.text "department_name"
      t.integer "position"    
    end
  end
end
