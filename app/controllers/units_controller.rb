class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  # GET /units
  # GET /units.json
  def index
    @units = Unit.order('created_at desc')
  end

  # GET /units/1
  # GET /units/1.json
  def show
    @uploads = @unit.uploads.order("created_at desc")
    @hash = Gmaps4rails.build_markers(@unit.building) do |building, marker|
      marker.lat building.latitude
      marker.lng building.longitude
    end
    @unit_rental_price_histories = @unit.rental_price_histories.order('created_at desc')
  end

  def units_search
    @units = Unit.where(building_id: params[:building_id]).search(params[:term])
  end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to unit_steps_path(unit_id: @unit.id), notice: 'Unit was successfully created.' }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to units_url, notice: 'Unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:building_id,:name,:description,:pros,:cons,:number_of_bedrooms,
                                   :number_of_bathrooms,:monthly_rent,:square_feet,:total_upfront_cost,
                                   :rent_start_date,:rent_end_date,:security_deposit,:broker_fee,
                                   :move_in_fee,:rent_upfront_cost,:processing_fee,:balcony,:board_approval_required,
                                   :converted_unit,:courtyard,:dishwasher,:fireplace,:furnished,:guarantors_accepted,
                                   :loft,:management_company_run,:rent_controlled,:private_landlord,:storage_available,
                                   :sublet,:terrace
                                   )
    end
end
