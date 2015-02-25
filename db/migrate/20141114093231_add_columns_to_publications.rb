class AddColumnsToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :issn, :text
    add_column :publications, :isbn, :text
    add_column :publications, :journaltitle, :text
  end
end
