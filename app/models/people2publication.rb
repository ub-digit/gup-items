class People2publication < ActiveRecord::Base
  belongs_to :publication
  
  validates :publication_id, presence: true
  validates :person_id, presence: true
  validates :position, presence: true, uniqueness: { scope: :publication_id}
end


