class BuildingsController < ApplicationController 
  before_action :authenticate_user!, except: [:index, :show, :contribute,:create]

  def index
    @buildings = Building.order('created_at desc')
    respond_to do |format|
      format.html
      format.json { 
        render json: Building.search(params[:term])
      }
    end
  end

  def contribute
    @buildings = Building.search(params[:term])
  end

  def show
    @building = Building.find(params[:id])
    @unit_review_count = 0
    @building.units.each do |unit|
      @unit_review_count = @unit_review_count + unit.reviews.count
    end
    @reviews = @building.reviews.order(created_at: :desc)
    @uploads = @building.uploads.order("created_at desc")
    
    @hash = Gmaps4rails.build_markers(@building) do |building, marker|
      marker.lat building.latitude
      marker.lng building.longitude
      #To add own marker
      # marker.picture ({
      #       "url" => "assets/marker.png",
      #       "width" => 32,
      #       "height" => 32})
    end
  end

  def new
    @building = Building.new
  end

  def create
    @building = Building.find_by_building_street_address(params[:building][:building_street_address])
    
    if @building.blank?
      @building = Building.create(building_params)

      if @building.save
        flash[:notice] = "Building Created."
        if params[:unit_contribution]
          contribute = params[:unit_contribution]
          unit_id = @building.units.last.id
        else
          contribute = params[:contribution]
          building_id = @building.id
        end
        if contribute.present?
          redirect_to user_steps_path(building_id: building_id, unit_id: unit_id, contribution_for: contribute)
        else
          redirect_to building_steps_path(building_id: @building.id)
        end
      else
        flash.now[:error] = "Error Creating"
        render :new
      end
    else
      if params[:unit_id].present?
        @unit = Unit.find(params[:unit_id])
      else
        @unit = @building.fetch_or_create_unit(params[:building][:units_attributes])
      end
      if params[:unit_contribution]
        contribute = params[:unit_contribution]
        unit_id = @building.units.last.id
      else
        contribute = params[:contribution]
        building_id = @building.id
      end
      redirect_to user_steps_path(building_id: @building.id, unit_id: @unit.id, contribution_for: contribute)
    end
  end

  def edit
    @building = Building.find(params[:id])
  end

  def update
    @building = Building.find(params[:id])
    if @building.update(building_params)
      if params[:subaction].blank?
        redirect_to building_path(@building), notice: "Successfully Updated"
      else
        redirect_to building_steps_path(building_id: @building.id)
      end
    else
      flash.now[:error] = "Error Updating"
      render :edit
    end
  end

  def destroy
    @building = Building.find(params[:id])
    @building.destroy

    redirect_to buildings_path, notice: "Successfully Deleted"
  end

  private


  def building_params
    params.require(:building).permit(:building_name, :building_street_address, :photo, :latitude, :longitude,:city,:state,:phone, :zipcode, :address2,:weburl,
                                      :pets_allowed,:laundry_facility,:parking,:doorman,:elevator,:description,
                                      :deck,:elevator,:garage,:gym,:live_in_super,:pets_allowed_cats,:pets_allowed_dogs,:roof_deck,:swimming_pool,:walk_up,
                                      uploads_attributes:[:id,:image,:imageable_id,:imageable_type], 
                                      units_attributes: [:id, :building_id, :name, :square_feet, :number_of_bedrooms, :number_of_bathrooms])
  end

end