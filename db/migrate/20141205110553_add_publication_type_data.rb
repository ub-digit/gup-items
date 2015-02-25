class AddPublicationTypeData < ActiveRecord::Migration
  def change
    pt=PublicationType.new(id: 0, publication_type_code: '- Välj -', content_type: '- Välj -', form_template: 'none', label: 'none')
    pt.save(:validate=>false)
  end
end
