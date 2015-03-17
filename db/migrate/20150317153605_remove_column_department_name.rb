class RemoveColumnDepartmentName < ActiveRecord::Migration
  def change
    remove_column :people2publications, :department_name
  end
end
