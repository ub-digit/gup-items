class AddColumnIsDeletedToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :is_deleted, :boolean
  end
end
