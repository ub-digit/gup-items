class AddColumnCreatedByToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :created_by, :text
  end
end
