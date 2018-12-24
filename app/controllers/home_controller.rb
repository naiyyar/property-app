require 'will_paginate/array'
class HomeController < ApplicationController
  before_action :reset_session, only: [:index, :auto_search]
  before_action :get_neighborhoods, only: [:index]
  before_action :format_search_string, only: :search

  def index
    @home_view = true
    @meta_desc = 'Transparentcity is the largest directory of links to no fee, '+
                  'no broker apartment buildings and reviews in NYC. '+  
                  'Rent from the source. Bypass middleman. Save money.'
  end

  def load_infobox
    building = Building.find(params[:object_id])

    render json: { html: render_to_string(:partial => "/layouts/shared/custom_infowindow", 
                     :locals => { 
                                  building: building,
                                  image: Upload.marker_image(building),
                                  rating_cache: building.rating_cache,
                                  recomended_per: Vote.recommended_percent(building),
                                  building_show: params[:building_show]
                                }) 
                  }
  end

  def auto_search
    # results = []
    @neighborhoods = Neighborhood.nb_search(params[:term]) #All neighborhoods
    # results << @buildings_by_pneighborhood
    @buildings = Building.search(params[:term])
    # results << @buildings_by_name
    #neighborhoods = Building.search_by_neighborhood(params[:term]).to_a.uniq(&:neighborhood)
    # results << @buildings_by_neighborhood
    # @buildings_by_address = Building.search_by_street_address(params[:term]).to_a.uniq(&:building_street_address)
    # results << @buildings_by_address
    @zipcodes = Building.search_by_zipcodes(params[:term]) #address and name
    # results << @buildings_by_zipcode
    #@city = Building.text_search_by_city(params[:term]) #.to_a.uniq(&:city)
    # results << @buildings_by_city
    @companies = ManagementCompany.text_search_by_management_company(params[:term])
    # results << @search_by_mangement
    #debugger
    # if !results.flatten.present?
    #   @result_type = 'no_match_found'
    # else
    #   @result_type = 'match_found'
    # end
    
    respond_to do |format|
      #format.html: because if login from search split view after searching something session was saving auto_search path as looking for auto_search template
      format.html { redirect_to root_url }
      format.json
      # format.json{
      #   @neighborhoods = @neighborhoods
      #   @buildings = @buildings
      #   @zipcodes = @zipcodes
      #   @companies = @companies
      # }
    end
  end

  def search
    search_term = params['search_term']
    if params[:searched_by] != 'address' and params[:searched_by] != 'management_company'
      @zoom = (@search_string == 'New York' ? 12 : 14)
      unless @search_string == 'New York'
        @brooklyn_neighborhoods =  @search_string #used to add border boundaries of brooklyn and queens
        @neighborhood_coordinates = Gcoordinate.neighbohood_boundary_coordinates(@search_string)

        @boundary_coords = []
        if params[:searched_by] == 'zipcode'
          @buildings = @searched_buildings = Building.where('zipcode = ?', @search_string)
          @boundary_coords << Gcoordinate.where(zipcode: @search_string).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
        elsif params[:searched_by] == 'neighborhoods'
          @buildings = @searched_buildings = Building.buildings_in_neighborhood(@search_string)
          @boundary_coords << @neighborhood_coordinates unless manhattan_kmls.include?(@search_string)
        else
          if @search_string == 'Manhattan'
            @boundary_coords << Gcoordinate.where(city: 'Manhattan').map{|rec| { lat: rec.latitude, lng: rec.longitude}}
          else
            if @search_string == 'Queens'
              boroughs = view_context.queens_sub_borough
            elsif @search_string == 'Brooklyn'
              boroughs = view_context.brooklyn_sub_borough
            elsif @search_string == 'Bronx'
              boroughs = view_context.bronx_sub_borough
            end
            @buildings = Building.where("city = ? OR neighborhood in (?)", @search_string, boroughs) 
            #buildings_in_city(@search_string)
            @zoom = 12
          end
        end
      else
        @buildings = Building.buildings_in_city(@search_string)
      end
    elsif params[:searched_by] == 'address'
      building = Building.where(building_street_address: params[:search_term])
      #searching because some address has extra white space in last so can not match exactly with address search_term
      building = Building.where('building_street_address like ?', "%#{params[:search_term]}%") if building.blank?
      redirect_to building_path(building.first) if building.present?
    elsif params[:searched_by] == 'management_company'
      @company = ManagementCompany.where(name: params[:search_term])
      redirect_to management_company_path(@company.first) if @company.present?
    end
    
    @buildings = Building.filtered_buildings(@buildings, params[:filter]) if params[:filter].present?
    @buildings = Building.sort_buildings(@buildings, params[:sort_by]) if (params[:sort_by].present? and @buildings.present?)
  
    #added unless @buildings.kind_of? Array => getting ratings sorting reasuls in array
    if @buildings.present?
      @buildings = @buildings unless @buildings.kind_of? Array
      @per_page_buildings = @buildings.paginate(:page => params[:page], :per_page => 20)
      @hash = Building.buildings_json_hash(@buildings)
      @lat = @hash[0]['latitude']
      @lng = @hash[0]['longitude']
      @photos_count = Upload.where(imageable_id: @buildings.map(&:id), imageable_type: 'Building').count
      @reviews_count = Review.where(reviewable_id: @buildings.map(&:id), reviewable_type: 'Building').count
    else
      if @boundary_coords.present? and @boundary_coords.first.length > 1
        @lat = @boundary_coords.first.first[:lat]
        @lng = @boundary_coords.first.first[:lng]
      else
        if @searched_buildings.present?
          @lat = @searched_buildings.first.latitude
          @lng = @searched_buildings.first.longitude
        elsif building.present?
          @lat = building.first.latitude
          @lng = building.first.longitude
        end
      end
    end
    
    @neighborhood_links = NeighborhoodLink.neighborhood_guide_links(@search_string, view_context.queens_borough)
    @meta_desc = "#{@tab_title_text.titleize} has #{@buildings.count if @buildings.present?} "+ 
                  "apartment rental buildings in NYC you can rent directly from and pay no broker fees. "+ 
                  "Click to view #{@photos_count} photos and #{@reviews_count} reviews."
  end

  def tos
  end

  private
  
  def manhattan_kmls
    ['Midtown', 'Sutton Place', 'Upper East Side', 'Yorkville', 'Bowery']
  end

  def reset_session
    session[:return_to] = nil if session[:return_to].present?
  end

  def get_neighborhoods
    @neighborhoods = Neighborhood.all
  end

  def format_search_string
    terms_arr =  params['search_term'].split('-')
    @borough_city = terms_arr.last
    @search_string = terms_arr.pop #removing last elements-name of city
    @search_string = terms_arr.join(' ').titleize #join neighborhoods
    @search_string = @search_string.gsub('  ', ' -') if @search_string == 'Flatbush   Ditmas Park'
    @search_string = @search_string.gsub(' ', '-') if @search_string == 'Bedford Stuyvesant'
    @search_string = 'New York' if @search_string == 'Newyork'
    
    @borough_city = (@borough_city == 'newyork' ? 'New York' : @borough_city.capitalize)
    @searched_neighborhoods = "#{@search_string}"
    @search_input_value = "#{@searched_neighborhoods} - #{@borough_city}, NY"
    @tab_title_text = "#{@search_string} #{@borough_city}"
  end
end