class AffiliationsController < ApplicationController

  def index
    person_id = params[:person_id]
  	if person_id
      publication_ids = Publication.where(is_draft: false).where(is_deleted: false).map {|publ| publ.id}
      puts publication_ids
      people2publicaion_ids = People2publication.where('publication_id in (?)', publication_ids).where('person_id = (?)', person_id.to_i).map { |p| p.id}
      affiliations = Departments2people2publication.where('people2publication_id in (?)', people2publicaion_ids).order(updated_at: :desc)
      render json: {affiliations: affiliations}, status: 200
    else
      render json: {affiliations: []}, status: 200
    end
  end
end
