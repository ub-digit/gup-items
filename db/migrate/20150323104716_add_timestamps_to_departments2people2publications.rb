class AddTimestampsToDepartments2people2publications < ActiveRecord::Migration
  def change
    add_column :departments2people2publications, :created_at, :datetime
    add_column :departments2people2publications, :updated_at, :datetime
  end
end
