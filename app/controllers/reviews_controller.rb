class ReviewsController < ApplicationController 
  before_action :authenticate_user!, :except => [:new]


  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    if params[:building_id]
      @reviewable = Building.find(params[:building_id])
    else
      @reviewable = Unit.find(params[:unit_id])
    end
  end

  def create
    if current_user.nil?
      # Store the form data in the session so we can retrieve it after login
      session[:form_data] = params
      # Redirect the user to register/login
      redirect_to new_user_registration_path    
 
    else
      @reviewable = find_reviewable
      @review = @reviewable.reviews.build(review_params)
      @review.user_id = current_user.id

      if @review.save
        if params[:vote]
          @reviewable.liked_by current_user
        else
          @reviewable.downvote_from current_user
        end
        flash[:notice] = "Review Created Successfully."
        redirect_to building_path(@reviewable)
      else
        flash.now[:error] = "Error Creating"
        render :new
      end
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update

    @review = Review.find(params[:id])

    if @review.update(review_params)
      redirect_to review_path(@review), notice: "Successfully Updated"
    else
      flash.now[:error] = "Error Updating"
      render :edit
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    redirect_to reviews_path, notice: "Successfully Deleted"
  end

  private

  def review_params
    params.require(:review).permit(:review_title, :building_id, :user_id, :reviewable_id, :reviewable_type,
                                    :pros, :cons, :other_advice, :tenant_status, :stay_time)
  end

  def find_reviewable
    params.each do |name, value|
      if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
      end
    end
  end

end