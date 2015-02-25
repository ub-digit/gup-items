class AddColumnPubidToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :pubid, :bigint
  end
end
