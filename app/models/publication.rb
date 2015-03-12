class Publication < ActiveRecord::Base
  default_scope {order('updated_at DESC')}
  
  belongs_to :publication_type
  has_many :people2publications
  nilify_blanks :types => [:text]

  validates_presence_of :pubid
  validate :uniqueness_of_pubid
  validates_inclusion_of :is_draft, in: [true, false]
  validates_inclusion_of :is_deleted, in: [true, false]
  validate :by_publication_type
  
  def self.get_next_pubid
    # PG Specific
    Publication.find_by_sql("SELECT nextval('publications_pubid_seq');").first.nextval.to_i
  end 


  def authors
     [{id: 1, 
       first_name: "Johan", 
       last_name: "Andersson", 
       year_of_birth: "1970", 
       departments: [{name: "Test1"}, {name: "Test2"}]},
      {id: 2, 
       first_name: "Niclas",
       last_name: "Magnusson", 
       year_of_birth: "1971", 
       departments: [{name: "Test1"}]}]
  end

  def as_json(options = {})
    super(methods: [:authors])
  end


  private
  def uniqueness_of_pubid
    # For a given pubid only one publication should be active
    if is_deleted == false && !Publication.where(pubid: pubid).where(is_deleted: false).empty?
      errors.add(:pubid, 'Pubid should be unique unless publication is deleted')
    end
  end

  def by_publication_type
    if !is_draft
      if publication_type.nil? || publication_type.id == PublicationType.find_by_label("none").id
        errors.add(:publication_type_id, 'Needs a publication type')
      else
        publication_type.validate_publication(self)
      end
    end
  end
end

