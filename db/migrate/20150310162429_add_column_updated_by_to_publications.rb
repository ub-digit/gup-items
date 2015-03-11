class AddColumnUpdatedByToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :updated_by, :text
  end
end
