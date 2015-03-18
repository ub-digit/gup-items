class RenameColumnDepartmentName < ActiveRecord::Migration
  def change
    rename_column :departments2people2publications, :department_name, :name
  end
end
