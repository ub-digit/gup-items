# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.configure do |c|
  c.include ControllerHelper
end

RSpec.describe PublicationTypesController, :type => :controller do
  before :each do
    WebMock.disable_net_connect!
  end
  after :each do
    WebMock.allow_net_connect!
  end
  describe "GET publication types" do
    it "should return correct json publication type data" do
      get :show, id: PublicationType.find_by_label('article-ref').id
      expect(json['publication_type']['publication_type_code']).to eq 'article'
    end
    it "should reject non-existing id" do
      get :show, id: -2
      expect(response.status).to eq 404
    end
    it "should return a root element" do
      get :show, id: PublicationType.find_by_label('article-ref').id
      expect(json['publication_type']).to be_kind_of(Hash)
    end

    it "should get the complete list of publication types" do
    	get :index
    	expect(json['publication_types']).to_not be nil
    end

  end
end
