class AddTimestampsToPeople2publications < ActiveRecord::Migration
  def change
    add_column :people2publications, :created_at, :datetime
    add_column :people2publications, :updated_at, :datetime
  end
end
