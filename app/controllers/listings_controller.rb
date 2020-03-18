class ListingsController < ApplicationController
  load_and_authorize_resource   only: [:index, :export]
  before_action :set_listing,   only: [:show, :edit, :update, :destroy]
  before_action :find_listings, only: [:change_status, :delete_all]
  before_action :format_date,   only: [:transfer, :export]
  before_action :filter_listings, only: [:index, :past_listings]
  after_action :update_building_rent, only:[:create, :update, :destroy]
  
  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def past_listings
    respond_to do |format|
      format.html
      format.js
    end
  end

  def change_status
    @listings.each do |listing|
      listing.update(active: params[:active])
    end
    redirect_to :back
  end
  
  def delete_all
    @listings.each do |listing|
      listing.destroy
      listing.update_rent(@listings.active)
    end
    redirect_to :back
  end

  def import
    buildings      = Building.where.not(building_street_address: nil)
    listings       = Listing.active     
    import_listing = ImportListing.new(params[:file])
    @errors        = import_listing.import_listings(buildings, listings)
    if @errors.present?
      flash[:error] = @errors
    else
      flash[:notice] = 'File Succesfully Imported.'
    end
    redirect_to :back
  end

  def transfer
    listings = Listing.between(@from_date, @to_date).inactive
    Listing.transfer_to_past_listings_table(listings)
    flash[:notice] = 'Listing Succesfully Transfered.'
    redirect_to :back
  end

  def export
    @listings = Listing.between(@from_date, @to_date)
    file_name = "Listings_#{params[:date_from]}_to_#{params[:date_to]}.#{params[:format]}"
    case params[:format]
      when 'xls'  then render xls:  'export'
      when 'xlsx' then render xlsx: 'export', filename: file_name
      when 'csv'  then render csv:  'export'
      else render action: 'index'
    end
  end

  def show_more
    @building = Building.find(params[:building_id])
    @rentals  = params[:listing_type].present? ? 'active' : 'past'
    @listings = @building.active_listings(params[:filter_params], @rentals)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def new
    @listing = Listing.new
  end

  def edit
  end

  def create
    @listing = Listing.new(listing_params)

    respond_to do |format|
      if @listing.save
        format.html { redirect_to listings_url, notice: 'Listing was successfully created.' }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to listings_url, notice: 'Listing was successfully updated.' }
        format.json { render :json => { success: true, data: @listing } }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:building_id,:unit,:building_id,
                                      :rent,:bed,:bath,:free_months,:owner_paid,
                                      :date_available,:rent_stabilize,:active,
                                      :building_address, :management_company,
                                      :date_active)
    end

    def find_listings
      @listings = Listing.where(id: params[:selected_ids])
    end

    def update_building_rent
      @listing.update_rent
    end

    def filter_listings
      klass = params[:modal] || listing_klass
      @filterrific = initialize_filterrific(
        klass.constantize,
        params[:filterrific],
        available_filters: [:default_listing_order, :search_query]
      ) or return
      @listings = @filterrific.find.paginate(:page => params[:page], :per_page => 100)
                                   .includes(:building, building: [:management_company])
                                   .default_listing_order
    end

    def format_date
      @from_date = Date.parse(params[:date_from])
      @to_date   = params[:date_to].present? ? Date.parse(params[:date_to]) : (@from_date + 1.month)
    end

    def listing_klass
      action_name == 'past_listings' ? 'PastListing' : 'Listing'
    end
end
