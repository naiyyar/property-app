class ManagementCompaniesController < ApplicationController
  load_and_authorize_resource
  before_action :set_management_company, only: [:show, :edit, :update, :destroy, :managed_buildings, :load_more_reviews]
  before_action :set_company_buildings, only: [:show, :edit, :managed_buildings, :load_more_reviews]
  
  # GET /management_companies_url
  # GET /management_companies.json
  def index
    @management_companies = ManagementCompany.includes(:buildings).order(name: :asc)
    @pagy, @management_companies = pagy(@management_companies, items: 100)
  end

  def managed_buildings
  end

  def load_more_reviews
    @reviews = Review.buildings_reviews(@buildings).order(id: :asc)
    @reviews = @reviews.where('id < ?', params[:object_id]).limit(10) if params[:object_id].present?
    
    respond_to do |format|
      format.html{ redirect_back(fallback_location: management_companies_path(@management_company)) }
      format.js
    end
  end

  # GET /management_companies/1
  # GET /management_companies/1.json
  def show
    
  end

  # GET /management_companies/new
  def new
    @management_company = ManagementCompany.new
  end

  # GET /management_companies/1/edit
  def edit
    @pagy, @buildings = pagy(@buildings)
    @manage_buildings = @buildings
  end

  # POST /management_companies
  # POST /management_companies.json
  def create
    @management_company = ManagementCompany.new(management_company_params)

    respond_to do |format|
      if @management_company.save
        @management_company.add_building(params[:managed_building_ids]) if params[:managed_building_ids].present?
        format.html { redirect_to management_companies_url, notice: 'Management company was successfully created.' }
        format.json { render :show, status: :created, location: @management_company }
      else
        format.html { render :new }
        format.json { render json: @management_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /management_companies/1
  # PATCH/PUT /management_companies/1.json
  def update
    @management_company.add_building(params[:managed_building_ids]) if params[:managed_building_ids].present?
    respond_to do |format|
      if @management_company.update(management_company_params)
        format.html { redirect_to management_companies_url, notice: 'Management company was successfully updated.' }
        format.json { render :show, status: :ok, location: @management_company }
      else
        format.html { render :edit }
        format.json { render json: @management_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /management_companies/1
  # DELETE /management_companies/1.json
  def destroy
    @management_company.destroy
    respond_to do |format|
      format.html { redirect_to management_companies_url, notice: 'Management company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_management_company
      @management_company = ManagementCompany.find(params[:id])
    end

    def set_company_buildings
      @buildings = @management_company.buildings
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def management_company_params
      params.require(:management_company).permit(:name, :website)
    end
end
