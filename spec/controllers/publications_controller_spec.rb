# -*- coding: utf-8 -*-
require 'rails_helper'
require 'fileutils'

RSpec.configure do |c|
  c.include ControllerHelper
end

RSpec.describe PublicationsController, :type => :controller do
  fixtures :publications

before :each do
  @valid_1_record = fixture_file_upload('files/valid_1_record.xml', 'text/xml')
  @valid_2_records = fixture_file_upload('files/valid_2_records.xml', 'text/xml')
  @invalid = fixture_file_upload('files/invalid.xml', 'text/xml')
  @unsupported_version = fixture_file_upload('files/unsupported_version.xml', 'text/xml')
  @empty = fixture_file_upload('files/empty.xml', 'text/xml')
end


  describe "GET publications" do
    context "index" do 
      it "should return a list of objects" do
        get :index
        expect(json["publications"]).to_not be nil
        expect(json["publications"]).to be_an(Array)
      end
      it "should return only no deleted publications" do
        get :index
        expect(json["publications"]).to_not be nil
        json["publications"].each do |p| 
          expect(p['is_deleted'] == false).to be_truthy
          expect(p['is_draft'] == false).to be_truthy
        end
      end  
    end

    context "drafts" do 
      it "should return a list of draft objects" do
        get :drafts
        expect(json["publications"]).to_not be nil
        expect(json["publications"]).to be_an(Array)
      end
      it "should return only no deleted drafts" do
        get :drafts
        expect(json["publications"]).to_not be nil
        json["publications"].each do |p| 
          expect(p['is_deleted'] == false).to be_truthy
          expect(p['is_draft'] == true).to be_truthy
        end
      end  
    end
  end

  describe "GET publication" do
    it "should return correct json publication data" do
      get :show, pubid: 1001
      expect(json['publication']['title']).to eq 'Test-title'
    end
    it "should reject non-existing id" do
      get :show, pubid: -2
      expect(response.status).to eq 404
    end
    it "should return a root element" do
      get :show, pubid: 1001
      expect(json['publication']).to be_kind_of(Hash)
    end
  end

  describe "POST publication" do
    context "for no required datasource" do
      it "should return a json" do
        post :create, datasource: "none", publication: {}
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)
      end
      it "should return a 201 (created) response" do
        post :create, datasource: "none", publication: {}
        expect(response.status).to eq 201
      end
      it "should save publication in database" do   
        post :create, datasource: "none", publication: {}
        publication = Publication.find_by_id(json['publication']['id'])
        expect(publication['id']).to be_truthy      
      end
      it "should set the publication as a draft" do
        post :create, datasource: "none", publication: {}
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['is_draft']).to eq true
      end
      it "should set the publication as no deleted" do
        post :create, datasource: "none", publication: {}
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['is_deleted']).to eq false
      end
      it "should generate a pubid for the publication" do
        post :create, datasource: "none", publication: {}
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['pubid']).to be_truthy
      end
    
      it "should ignore any no existing field" do
        post :create, datasource: "none", publication: {
          dummy_field: "dummy value"
        }
        expect(json).to be_kind_of(Hash)
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['dummy_field']).to be_falsey
      end
    end

    context "for required datasource pubmed and an existing id" do
      it "should return the created publication and a 201 response" do
        post :create, datasource: "pubmed", sourceid: "25505574", publication: {}
        expect(response.status).to eq 201
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)   
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['pubid']).to be_truthy
        expect(json['publication']['title']).to be_truthy
        expect(json['publication']['pubyear']).to be_truthy
      end
    end
    context "for required datasource pubmed and a no existing id" do
      it "should return a error message and 422 response" do
        post :create, datasource: "pubmed", sourceid: "25505574999999999", publication: {}
        expect(response.status).to eq 422
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)   
        expect(json['errors']).to be_truthy
      end
    end

    context "for required datasource gupea and an existing id" do
      it "should return the created publication and a 201 response" do
        post :create, datasource: "gupea", sourceid: "12345", publication: {}
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)   
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['pubid']).to be_truthy
        expect(json['publication']['title']).to be_truthy
        expect(json['publication']['pubyear']).to be_truthy
      end
    end
    context "for required datasource gupea and a no existing id" do
      it "should return a error message and 422 response" do
        post :create, datasource: "gupea", sourceid: "12345321654", publication: {}
        expect(response.status).to eq 422
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)   
        expect(json['errors']).to be_truthy
      end
    end

    context "for required datasource scopus and an existing id" do
      it "should return the created publication and a 201 response" do
        post :create, datasource: "scopus", sourceid: "10.1109/IJCNN.2008.4634188", publication: {}
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)   
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['pubid']).to be_truthy
        expect(json['publication']['title']).to be_truthy
        expect(json['publication']['pubyear']).to be_truthy      
      end
    end
    context "for required datasource gupea and an existing id" do
      it "should return a error message and 422 response" do
        post :create, datasource: "scopus", sourceid: "11223344/667788994455", publication: {}
        expect(response.status).to eq 422
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)   
        expect(json['errors']).to be_truthy
      end
    end

    context "for required datasource libris and an existing id" do
      it "should return the created publication and a 201 response" do
        post :create, datasource: "libris", sourceid: "978-91-637-1542-6", publication: {}
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)   
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['pubid']).to be_truthy
        expect(json['publication']['title']).to be_truthy
        expect(json['publication']['pubyear']).to be_truthy      
      end
    end
    context "for required datasource gupea and an existing id" do
      it "should return a error message and 422 response" do
        post :create, datasource: "libris", sourceid: "1234569789978-91-637-1542-6", publication: {}
        expect(response.status).to eq 422
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)   
        expect(json['errors']).to be_truthy
      end
    end



    context "when creating a publication by importing a valid xml file with one record" do
      it "should return a json and a 201 (created) response" do
        post :import_file, file: @valid_1_record
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)
        expect(response.status).to eq 201
      end
      it "should return valid fields (tests only a selection)" do
        post :import_file, file: @valid_1_record
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['pubid']).to be_truthy
        expect(json['publication']['is_draft']).to eq true
        expect(json['publication']['is_deleted']).to eq false
        expect(json['publication']['title']).to eq 'Valid title'
        expect(json['publication']['pubyear']).to eq 2013
        expect(json['publication']['abstract']).to eq 'This is a validity test'
        expect(json['publication']['issn']).to eq '1234-5678'
      end
    end

    context "when creating a publication by importing a valid xml file with two records" do
      it "should return a json and a 201 (created) response" do
        post :import_file, file: @valid_2_records
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)
        expect(response.status).to eq 201
      end
      it "should return valid fields for the first imported publication (tests only a selection)" do
        post :import_file, file: @valid_2_records
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['pubid']).to be_truthy
        expect(json['publication']['is_draft']).to eq true
        expect(json['publication']['is_deleted']).to eq false
        expect(json['publication']['title']).to eq 'Valid title'
        expect(json['publication']['pubyear']).to eq 2013
        expect(json['publication']['abstract']).to eq 'This is a validity test'
        expect(json['publication']['issn']).to eq '1234-5678'
      end
    end

    context "when creating a publication by importing a file with invalid xml" do
      it "should return a json and a 422 response" do
        post :import_file, file: @invalid
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)
        expect(response.status).to eq 422
      end
    end
    context "when creating a publication by importing an empty file" do
      it "should return a json and a 422 response" do
        post :import_file, file: @empty
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)
        expect(response.status).to eq 422
      end
    end
    context "when creating a publication by importing file that is created with an unsupported Endnote version" do
      it "should return a json and a 422 response" do
        post :import_file, file: @unsupported_version
        expect(json).to_not be nil
        expect(json).to be_kind_of(Hash)
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT publication" do
    it "should save publication in database" do
      post :create, datasource: "none", publication: {}
      tmp = JSON.parse(response.body)
      pubid = tmp['publication']['pubid']
      put :update, pubid: pubid, publication: {
        is_draft: "false",
        publication_type_id: PublicationType.find_by_label('article-ref').id.to_s,
        title: "Test-title", 
        author: "Bengt Sändh", 
        pubyear: 2014, 
        abstract: "This is an abstract...",
        issn: "1234-5678",
        isbn: "987654321",
        alt_title: "Test-alt-title",
        publanguage: "de",
        extid: "123",
        links: "http://123456",
        url: "http://98765",
        category_hsv_local: "matematik",
        keywords: "alger",
        pub_notes: "987654321",
        sourcetitle: "Testtidsskrift-titel",
        sourcevolume: "2",
        sourceissue: "33",
        sourcepages: "123-456",
        project: "Test-projekt",
        eissn: "9876-9876",
        extent: "100",
        publisher: "Test-publisher",
        place: "Fest-plats",
        series: "Best-serie",
        artwork_type: "Installation",
        dissdate: "1044",
        disstime: "00:00:00",
        disslocation: "Stonehenge",
        dissopponent: "Bo Giertz",
        patent_applicant: "Einstein",
        patent_application_number: "1234",
        patent_application_date: "2013-12-12",
        patent_number: "9999",
        patent_date: "2013-11-11"
      }
      publication = Publication.find_by_id(json['publication']['id'])
      expect(publication['id']).to be_truthy
      expect(publication['is_draft']).to eq false      
      expect(publication['publication_type_id']).to eq PublicationType.find_by_label('article-ref').id
      expect(publication['title']).to eq 'Test-title'
      expect(publication['author']).to eq 'Bengt Sändh'
      expect(publication['pubyear']).to be >= 1500
      expect(publication['abstract']).to eq 'This is an abstract...'
      expect(publication['issn']).to eq '1234-5678'
      expect(publication['isbn']).to eq nil
      expect(publication['alt_title']).to eq 'Test-alt-title'
      expect(publication['publanguage']).to eq 'de'
      expect(publication['extid']).to eq '123'
      expect(publication['links']).to eq 'http://123456'
      expect(publication['url']).to eq 'http://98765'
      expect(publication['category_hsv_local']).to eq 'matematik'
      expect(publication['keywords']).to eq 'alger'
      expect(publication['pub_notes']).to eq '987654321'
      expect(publication['sourcetitle']).to eq 'Testtidsskrift-titel'
      expect(publication['sourcevolume']).to eq '2'
      expect(publication['sourceissue']).to eq '33'
      expect(publication['sourcepages']).to eq '123-456'
      expect(publication['project']).to eq 'Test-projekt'
      expect(publication['eissn']).to eq '9876-9876'
      expect(publication['extent']).to eq nil
      expect(publication['publisher']).to eq nil
      expect(publication['place']).to eq nil
      expect(publication['series']).to eq nil
      expect(publication['artwork_type']).to eq nil
      expect(publication['dissdate']).to eq nil
      expect(publication['disstime']).to eq nil
      expect(publication['disslocation']).to eq nil
      expect(publication['dissopponent']).to eq nil
      expect(publication['patent_applicant']).to eq nil
      expect(publication['patent_application_number']).to eq nil
      expect(publication['patent_application_date']).to eq nil
      expect(publication['patent_number']).to eq nil
      expect(publication['patent_date']).to eq nil
    end

    context "for publication type with form template article" do
      it "should return the saved publication and a 200 (ok) response" do
        post :create, datasource: "none", publication: {}
        tmp = JSON.parse(response.body)
        pubid = tmp['publication']['pubid']        
        put :update, pubid: pubid, publication: {
          is_draft: "false",
          publication_type_id: PublicationType.find_by_label('article-pop').id.to_s,
          title: "Test-title", 
          author: "Bengt Sändh", 
          pubyear: "2014", 
          abstract: "This is an abstract...",
          issn: "1234-5678",
          isbn: "987654321",
          alt_title: "Test-alt-title",
          publanguage: "de",
          extid: "123",
          links: "http://123456",
          url: "http://98765",
          category_hsv_local: "matematik",
          keywords: "alger",
          pub_notes: "987654321",
          sourcetitle: "Testtidsskrift-titel",
          sourcevolume: "2",
          sourceissue: "33",
          sourcepages: "123-456",
          project: "Test-projekt",
          eissn: "9876-9876",
          article_number: "52_17:23",
          extent: "100",
          publisher: "Test-publisher",
          place: "Fest-plats",
          series: "Best-serie",
          artwork_type: "Installation",
          dissdate: "1044",
          disstime: "00:00:00",
          disslocation: "Stonehenge",
          dissopponent: "Bo Giertz",
          patent_applicant: "Einstein",
          patent_application_number: "1234",
          patent_application_date: "2013-12-12",
          patent_number: "9999",
          patent_date: "2013-11-11"
        }
        expect(json).to be_kind_of(Hash)    
        expect(response.status).to eq 200
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['is_draft']).to eq false      
        expect(json['publication']['publication_type_id']).to eq PublicationType.find_by_label('article-pop').id     
        expect(json['publication']['title']).to eq 'Test-title'
        expect(json['publication']['author']).to eq 'Bengt Sändh'
        expect(json['publication']['pubyear']).to be >= 1500
        expect(json['publication']['abstract']).to eq 'This is an abstract...'
        expect(json['publication']['issn']).to eq '1234-5678'
        expect(json['publication']['isbn']).to eq nil
        expect(json['publication']['alt_title']).to eq 'Test-alt-title'
        expect(json['publication']['publanguage']).to eq 'de'
        expect(json['publication']['extid']).to eq '123'
        expect(json['publication']['links']).to eq 'http://123456'
        expect(json['publication']['url']).to eq 'http://98765'
        expect(json['publication']['category_hsv_local']).to eq 'matematik'
        expect(json['publication']['keywords']).to eq 'alger'
        expect(json['publication']['pub_notes']).to eq '987654321'
        expect(json['publication']['sourcetitle']).to eq 'Testtidsskrift-titel'
        expect(json['publication']['sourcevolume']).to eq '2'
        expect(json['publication']['sourceissue']).to eq '33'
        expect(json['publication']['sourcepages']).to eq '123-456'
        expect(json['publication']['project']).to eq nil
        expect(json['publication']['eissn']).to eq '9876-9876'
        expect(json['publication']['article_number']).to eq '52_17:23'
        expect(json['publication']['extent']).to eq nil
        expect(json['publication']['publisher']).to eq nil
        expect(json['publication']['place']).to eq nil
        expect(json['publication']['series']).to eq nil
        expect(json['publication']['artwork_type']).to eq nil
        expect(json['publication']['dissdate']).to eq nil
        expect(json['publication']['disstime']).to eq nil
        expect(json['publication']['disslocation']).to eq nil
        expect(json['publication']['dissopponent']).to eq nil
        expect(json['publication']['patent_applicant']).to eq nil
        expect(json['publication']['patent_application_number']).to eq nil
        expect(json['publication']['patent_application_date']).to eq nil
        expect(json['publication']['patent_number']).to eq nil
        expect(json['publication']['patent_date']).to eq nil
      end
    end


    context "for publication type with form template article-ref" do
      it "should return the saved publication" do
        post :create, datasource: "none", publication: {}
        tmp = JSON.parse(response.body)
        pubid = tmp['publication']['pubid']
        put :update, pubid: pubid, publication: {
          is_draft: "false",
          publication_type_id: PublicationType.find_by_label('article-ref').id.to_s,
          title: "Test-title", 
          author: "Bengt Sändh", 
          pubyear: "2014", 
          abstract: "This is an abstract...",
          sourcetitle: "Test-journal",
          issn: "1234-5678",
          isbn: "987654321"
        }
        expect(json).to be_kind_of(Hash)
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['is_draft']).to eq false
        expect(json['publication']['publication_type_id']).to eq PublicationType.find_by_label('article-ref').id
        expect(json['publication']['title']).to eq 'Test-title'
        expect(json['publication']['author']).to eq 'Bengt Sändh'
        expect(json['publication']['pubyear']).to be >= 1500
        expect(json['publication']['abstract']).to eq 'This is an abstract...'
        expect(json['publication']['sourcetitle']).to eq 'Test-journal'
        expect(json['publication']['issn']).to eq '1234-5678'
        expect(json['publication']['isbn']).to eq nil    
      end
    end

    context "for any publication type" do
      it "should return errors when save fails" do
        post :create, datasource: "none", publication: {}
        tmp = JSON.parse(response.body)
        pubid = tmp['publication']['pubid']        
        put :update, pubid: pubid, publication: {
          is_draft: "false",
          publication_type_id: PublicationType.find_by_label('article-ref').id.to_s, 
          author: "Bengt Sändh", 
          pubyear: "2014", 
          abstract: "This is an abstract..."
        }
        expect(json).to be_kind_of(Hash)
        expect(json['errors']).to be_kind_of(Hash)
        expect(json['errors']['title']).to be_kind_of(Array)
      end

      it "should ignore any no existing field" do
        post :create, datasource: "none", publication: {}
        tmp = JSON.parse(response.body)
        pubid = tmp['publication']['pubid']
        put :update, pubid: pubid, publication: {
          is_draft: "false",
          dummy_field: "dummy value",
          publication_type_id: PublicationType.find_by_label('article-pop').id.to_s,
          title: "Test-title", 
          author: "Bengt Sändh", 
          pubyear: "2014"
        }
        expect(json).to be_kind_of(Hash)
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['dummy_field']).to be_falsey
      end
    end
    context "for no publication type" do
      it "should return the publication when saving a draft" do
        post :create, datasource: "none", publication: {}
        tmp = JSON.parse(response.body)
        pubid = tmp['publication']['pubid']
        put :update, pubid: pubid, publication: {
          is_draft: "true"
        }
        expect(json).to be_kind_of(Hash)
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['is_draft']).to eq true
      end
    end
    context "for publication type with form template none" do
      it "should return the publication when saving a draft" do
        post :create, datasource: "none", publication: {}
        tmp = JSON.parse(response.body)
        pubid = tmp['publication']['pubid']
        put :update, pubid: pubid, publication: {
          is_draft: "true",
          publication_type_id:PublicationType.find_by_label('none').id.to_s,
        }
        expect(json).to be_kind_of(Hash)
        expect(json['publication']['id']).to be_truthy
        expect(json['publication']['is_draft']).to eq true
        expect(json['publication']['publication_type_id']).to eq PublicationType.find_by_label('none').id
      end
    end
  end

  describe "DELETE publication" do
    it "should set the publication to deleted in the database" do
      post :create, datasource: "none", publication: {}
      tmp = JSON.parse(response.body)
      pubid = tmp['publication']['pubid']
      id = tmp['publication']['id']

      delete :delete, pubid: pubid
      expect(json).to be_kind_of(Hash)
      publication = Publication.find_by_id(id)
      expect(publication['is_deleted']).to eq true      
    end
  end

end
