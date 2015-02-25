class AddPubidSequence < ActiveRecord::Migration
  def change
  	# PG Specific
    execute "CREATE SEQUENCE publications_pubid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1000 CACHE 1;"  
  end
end
