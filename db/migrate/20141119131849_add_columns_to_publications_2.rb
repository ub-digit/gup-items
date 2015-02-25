class AddColumnsToPublications2 < ActiveRecord::Migration
  def change
    add_column :publications, :publication_type_id, :integer

    add_column :publications, :alt_title, :text
    add_column :publications, :publanguage, :text
    add_column :publications, :extid, :text

    add_column :publications, :links, :text
    add_column :publications, :url, :text
    add_column :publications, :category_hsv_local, :text
    add_column :publications, :keywords, :text
    add_column :publications, :pub_notes, :text
    add_column :publications, :journal, :text
    add_column :publications, :sourcetitle, :text
    add_column :publications, :sourcevolume, :text
    add_column :publications, :sourceissue, :text
    add_column :publications, :sourcepages, :text
    add_column :publications, :project, :text
    add_column :publications, :eissn, :text
    add_column :publications, :extent, :text
    add_column :publications, :publisher, :text
    add_column :publications, :place, :text
    add_column :publications, :series, :text
    add_column :publications, :artwork_type, :text
    add_column :publications, :dissdate, :text
    add_column :publications, :disstime, :text
    add_column :publications, :disslocation, :text
    add_column :publications, :dissopponent, :text
    add_column :publications, :patent_applicant, :text
    add_column :publications, :patent_application_number, :text
    add_column :publications, :patent_application_date, :text
    add_column :publications, :patent_number, :text
    add_column :publications, :patent_date, :text

  end
end
