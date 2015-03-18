# -*- coding: utf-8 -*-
class PublicationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    publications = Publication.where(is_draft: false).where(is_deleted: false)
    render json: {publications: publications}, status: 200
  end
  
  def drafts
    publications = Publication.where(is_draft: true).where(is_deleted: false)
    render json: {publications: publications}, status: 200
  end

  def show
    pubid = params[:pubid]
    publication = Publication.where(is_deleted: false).find_by_pubid(pubid)
    if publication.nil?
      render json: {errors: 'Publikationen kunde tyvärr inte hittas.'}, status: 404
    else
      render json: {publication: publication}, status: 200
    end
  end

  def create
    params[:publication] = {} if !params[:publication]

    adapter = params[:datasource]
    if adapter.eql?("none")
      # do nothing
    elsif adapter.eql?("pubmed")
      pubmed = Pubmed.find_by_id(params[:sourceid])
      if pubmed && pubmed.errors.messages.empty?
        params[:publication].merge!(pubmed.as_json)
      else
        render json: {errors: 'Identifikatorn hittades inte i Pubmed.'}, status: 422
        return
      end

    elsif adapter.eql?("gupea")
      gupea = Gupea.find_by_id(params[:sourceid])
      if gupea && gupea.errors.messages.empty?
        params[:publication].merge!(gupea.as_json)
      else
        render json: {errors: 'Identifikatorn hittades inte i GUPEA.'}, status: 422
        return
      end    

    elsif adapter.eql?("scopus")
      scopus = Scopus.find_by_id(params[:sourceid])
      if scopus && scopus.errors.messages.empty?
        params[:publication].merge!(scopus.as_json)
      else
        render json: {errors: 'Identifikatorn hittades inte i Scopus.'}, status: 422
        return
      end

    elsif adapter.eql?("libris")
      libris = Libris.find_by_id(params[:sourceid])
      if libris && libris.errors.messages.empty?
        params[:publication].merge!(libris.as_json)
      else
        render json: {errors: 'Identifikatorn hittades inte i Libris.'}, status: 422
        return
      end
    
#    elsif adapter.eql?("crossref")
#      crossref = Crossref.find_by_id(params[:sourceid])
#      if crossref && crossref.errors.messages.empty?
#        params[:publication].merge!(crossref.as_json)
#      else
#        render json: {errors: 'Identifikatorn hittades inte i Crossref.'}, status: 422
#        return
#      end       
    elsif adapter.nil? && params[:file]
      handle_file_import
      return
    end

    create_basic_data
    pub = Publication.new(permitted_params(params))
    if pub.save
      render json: {publication: pub}, status: 201
    else
      render json: {errors: pub.errors}, status: 422
    end    
  end

  def handle_file_import 
    raw_xml = params[:file].read 
    if raw_xml.blank?
      render json: {errors: 'Filen innehåller ingen data.'}, status: 422
      return
    end      
    xml = Nokogiri::XML(raw_xml)
    if !xml.errors.empty?
      render json: {errors: 'Filen är inte valid.'}, status: 422
      return
    end

    # check versions
    version_list = xml.search('//source-app').map do |element|
      element.attr("version").to_f
    end
    version_list = version_list.select! do |version|
      version < 8
    end
    if !version_list.empty?
     render json: {errors: 'Filen är skapad av versioner av Endnote som inte stöds.'}, status: 422
     return
    end     

    record_count = 0
    record_total = 0
    return_pub = {}

    xml.search('//xml/records/record').each do |record|
      record_total += 1
      params[:publication] = {}
      endnote = Endnote.parse(record)
      if endnote
        params[:publication].merge!(endnote.as_json)
      else
        params[:publication][:title] = "[Title not found]"
      end

      create_basic_data
      pub = Publication.new(permitted_params(params))
      if pub.save
        record_count += 1
        if record_count == 1
          return_pub = pub
        end
      else
        render json: {errors: pub.errors}, status: 422
      end    
    end
    render json: {publication: return_pub, meta: {result: {count: record_count, total: record_total}}}, status: 201
  end

  def import_file
    handle_file_import
  end


  def create_basic_data
    pubid = Publication.get_next_pubid
    params[:publication][:pubid] = pubid
    params[:publication][:is_draft] = true
    params[:publication][:is_deleted] = false
    params[:publication][:publication_type_id] = PublicationType.find_by_label('none').id  
  end

  def update
    pubid = params[:pubid]
    publication_old = Publication.where(is_deleted: false).find_by_pubid(pubid)
    if publication_old
      params[:publication][:pubid] = publication_old.pubid
      params[:publication][:is_deleted] = true

      if !params[:publication][:publication_type_id] || (params[:publication][:publication_type_id].to_i == PublicationType.find_by_label('none').id)  
        publication_new = Publication.new(permitted_params(params))
      else
        publication_new = Publication.new(permitted_pubtype_params(params[:publication][:publication_type_id]))
      end
      if publication_new.save
        publication_old.update_attribute(:is_deleted, true)
        publication_new.update_attribute(:is_deleted, false)
        publication_new.update_attribute(:pubid, publication_old.pubid)
        create_affiliation publication_new.id, params[:people2publications] unless params[:people2publications].blank?
        render json: {publication: publication_new}, status: 200
      else
        render json: {errors: publication_new.errors}, status: 422
      end
    else
      render json: {errors: 'Publikationen kunde tyvärr inte hittas.'}, status: 404
    end
  end

  def create_affiliation publication_id, people2publications
    people2publications.each.with_index do |p2p, i|
      p2p_obj = People2publication.create({publication_id: publication_id, person_id: p2p[:person_id], position: i + 1})
      department_list = p2p[:departments2people2publications]
      department_list.each.with_index do |d2p2p, j|
        Departments2people2publication.create({people2publication_id: p2p_obj.id, name: d2p2p[:name], position: j + 1})
      end
    end
  end


  def delete
    pubid = params[:pubid]
    publication = Publication.where(is_deleted: false).find_by_pubid(pubid)
    if publication
      publication.update_attribute(:is_deleted, true)
    else
      # do nothing, log...
    end
    render json: {}, status: 200
  end


  def permitted_params(params)
    params.require(:publication).permit(PublicationType.get_all_fields)
  end

  def permitted_pubtype_params(pubtype_id)
    PublicationType.find(pubtype_id).permitted_params(params)
  end
end
