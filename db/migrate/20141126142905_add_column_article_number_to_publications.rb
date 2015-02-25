class AddColumnArticleNumberToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :article_number, :text
  end
end
