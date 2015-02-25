class RemoveJournalAndJournaltitleColumnsFromPublications < ActiveRecord::Migration
  def change
    remove_column :publications, :journal
    remove_column :publications, :journaltitle
  end
end
