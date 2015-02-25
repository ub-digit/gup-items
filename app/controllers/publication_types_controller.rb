# -*- coding: utf-8 -*-
class PublicationTypesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    publication_types = PublicationType.all
    render json: {publication_types: publication_types}, status: 200    
  end

  def show
    id = params[:id]
    publication_type = PublicationType.find_by_id(id)
    if publication_type.nil?
      render json: {errors: 'Publikationstypen kunde tyvärr inte hittas.'}, status: 404
    else
      render json: publication_type.to_json(root: true)
    end
  end

  def create
    pub = PublicationType.new(permitted_params)
    if pub.save
      render json: pub.to_json(root: true)
    else
      render json: {errors: pub.errors}, status: 400
    end
  end


  def permitted_params
  	params.require(:publication_type).permit(:code)
  end

end
