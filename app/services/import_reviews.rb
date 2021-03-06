class ImportReviews < ImportService

	def initialize file
		super
		@user = User.find_by_email('reviews@myapp.com')
	end

	def import_reviews
    (2..@spreadsheet.last_row).each do |i|
      @row = Hash[[@header, @spreadsheet.row(i)].transpose ]
      if @row['building_address'].present?
        @buildings = get_buildings
        @building  = unless @buildings.present?
                      create_building
                    else
                      @buildings.first
                    end
        create_review(@row) if @building.present? and @building.id.present?
      end
    end
  end

  def create_review
    rev = Review.new
    rev.attributes = row.to_hash.slice(*row.to_hash.keys[5..8])
    
    rev[:reviewable_id]   = @building.id
    rev[:reviewable_type] = 'Building'
    rev[:anonymous]       = true
    rev[:created_at]      = DateTime.parse(row['created_at'])
    rev[:updated_at]      = DateTime.parse(row['created_at'])
    rev[:user_id]         = @user.id
    rev[:tos_agreement]   = true
    rev[:scraped]         = true
    rev.save!
    save_votes(@row) if rev.present? and rev.id.present?
  end

  private

  def save_votes row
    @user.create_rating(row['rating'], @building, rev.id, 'building')
    @vote = if (row['vote'].present? and row['vote'] == 'yes')
              @user.vote_for(@building)
            else
              @user.vote_against(@building)
            end
    
    if @vote.present?
      @vote.review_id = rev.id
      @vote.save
    end
  end

  def get_buildings row
    Building.where(building_street_address: @row['building_address'], 
                   zipcode: @row['zipcode'])
  end

  def create_building
  	Building.create({ 
  										building_street_address: @row['building_address'], 
                      city: @row['city'], 
                      state: 'NY', 
                      zipcode: @row['zipcode']
                    })
  end

end