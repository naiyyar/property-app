class UsersController < ApplicationController
	load_and_authorize_resource :find_by => :slug 
	before_action :authenticate_user!, only: [:show, :edit, :saved_buildings]
	before_action :set_user, only: [:edit, :update, :show, :contribution, :saved_buildings, :managertools]

	def index
		@users = User.order('created_at desc')
								 .includes(:buildings, :favorites)
								 .paginate(:page => params[:page], :per_page => 100)
	end

	def contribution
	end

	def saved_buildings
		# @rent_medians 	= RentMedian.all
		# @broker_percent = BrokerFeePercent.first.percent_amount
		@buildings 			= Building.saved_favourites(@user)
												 			.paginate(:page => params[:page], :per_page => 20)
												 			.includes(:featured_buildings)
    
    @photos 				= Upload.building_photos(@buildings.pluck(:id))
		@hash 					= Building.buildings_json_hash(@buildings)
    @zoom 					= 12
    @show_map_btn 	= @half_footer = true
	end

	def managertools
		@type 					  = params[:type]
		session[:back_to] = request.fullpath
		unless @type == 'billing'
			@filterrific = initialize_filterrific(
	      FeaturedBuilding,
	      params[:filterrific],
	      available_filters: [:search_query]
	    ) or return

	    @featured_buildings = @filterrific.find
	    																	.where(user_id: @user.id).by_manager
	    																	.paginate(:page => params[:page], :per_page => 100)
	    																	.includes(:billings, :building => [:management_company])
	    																	.order('created_at desc')
	  else
	  	@billings = @current_user.billings
    														.includes(:featured_building)
    														.paginate(:page => params[:page], :per_page => 100)
	  	@saved_cards = BillingService.new.get_saved_cards(current_user)
	  end

    respond_to do |format|
      format.html
      format.js
    end
	end

	def new
	end

	def show
		
	end

	def edit
		@buildings = @user.buildings.includes(:uploads, :building_average, :units).paginate(:page => params[:page], :per_page => 20)
	end

	def create
	end

	def update
		if @user.update_attributes(user_params)
			redirect_to user_path(@user), notice: 'User updated successfully'
		else
			render :edit, error: 'Error in saving...'
		end
	end

	def destroy
	end


	private

	def set_user
		if current_user.present?
			@user = current_user
		else
			#@user = User.find(params[:id])
			@user = User.friendly.find(params[:id])
		end
	end

	def user_params
		params.require(:user).permit(:name, :phone, :mobile, :about_me, :email, :avatar)
	end
end