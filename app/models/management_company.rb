# == Schema Information
#
# Table name: management_companies
#
#  id         :integer          not null, primary key
#  name       :string
#  website    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

=begin 
	======Schema =======
	name 			string
	website 	string
=end

class ManagementCompany < ActiveRecord::Base
	has_many :buildings
	validates :website, :url => true, allow_blank: true

	#pgsearch
	include PgSearch
  pg_search_scope :text_search_by_management_company, against: [:name],
     :using => { :tsearch => { prefix: true } }

	#methods

	def to_param
    if name.present?
      "#{id} #{name}".parameterize
    end
  end

  def company_buildings
  	buildings.reorder(neighborhood: :asc, building_name: :asc, building_street_address: :asc).includes(:featured_building)
  end

  def cached_company_buildings_count
  	company_buildings.count
  end

  def cached_buildings
  	Rails.cache.fetch([self, 'company_buildings']) { company_buildings }
  end
	
	def add_building building_ids
		Building.where(id: building_ids).update_all(management_company_id: self.id)
	end

	def aggregate_reviews
		count = 0
		self.buildings.each do |building|
			count += building.reviews_count
		end
		count
	end

	def recommended_percent
		downcount = total_reviews = 0
		buildings.includes(:reviews).each do |building|
			if building.reviews.present?
				downcount += building.downvotes_count
				total_reviews += building.reviews.count
			end
		end
		upcount = total_reviews - downcount
		return (upcount.to_f / total_reviews) * 100
	end

	def get_average_stars
  	@total_rates = 0
    star_counts = []

    # @total_rates = RatingCache.where(cacheable_id: buildings.pluck(:id))
    #                           .joins('LEFT JOIN buildings on rating_caches.cacheable_id = buildings.id')
    #                           .where(dimension: 'building')
    #                           .where.not(avg: [nil, 'NaN']).sum(:avg)
    rateables = Rate.where(rateable_id: buildings.pluck(:id), rateable_type: 'Building', dimension: 'building')
    @total_rates = rateables.where('stars > ?', 0).sum(:stars)

    star_counts = (@total_rates.to_f/aggregate_reviews).round(2).to_s.split('.')
    return star_counts
  end

end
