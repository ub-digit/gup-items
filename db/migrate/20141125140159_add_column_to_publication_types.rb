class AddColumnToPublicationTypes < ActiveRecord::Migration
  def change
  	add_column :publication_types, :label, :text

    PublicationType.reset_column_information
  end
end
