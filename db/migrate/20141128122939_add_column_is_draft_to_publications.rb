class AddColumnIsDraftToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :is_draft, :boolean
  end
end
