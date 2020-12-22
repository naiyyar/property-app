module Buildings
	module FeaturedBuildings
		PER_PAGE = 20

		def with_featured_buildings buildings
	    final_results      = {}
	    top2_featured      = top2_featured_buildings(buildings, @searched_by)
	    non_featured       = non_featured_buildings(buildings, top2_featured, @sort_by)
	    per_page_buildings = non_featured.paginate(:page => page_num, :per_page => PER_PAGE)
	    all_buildings      = buildings_with_featured_on_top(top2_featured, per_page_buildings)
	    
	    buildings = top2_featured + non_featured if top2_featured.present?
	    # when there are only top two featured buildings after filter
	    # then per_page_buildings will be blank due to fitering featured buildings
	    if per_page_buildings.blank? && all_buildings.present?
	      per_page_buildings = all_buildings.paginate(:page => page_num, :per_page => PER_PAGE)
	    end
	    
	    final_results[:all_buildings] = all_buildings
	    final_results[:map_hash]      = Building.buildings_json_hash(buildings)
	    
	    return final_results[:all_buildings], final_results[:map_hash], per_page_buildings
	  end

	  # putting featured building on top
	  def buildings_with_featured_on_top top_2, per_page
	    top_2.present? ? (top_2 + per_page) : per_page
	  end

	  def non_featured_buildings buildings, top_2, sort_by
	    buildings = buildings.where.not(id: top_2.map(&:id)) if top_2.present?
	    return buildings.sort_buildings(buildings, sort_by, @filters)
	  end

	  def top2_featured_buildings buildings, searched_by
	    fb_ids = featured_building_ids(buildings.pluck(:id), searched_by)
	    return [] if fb_ids.blank?
	    shuffled_ids = fb_ids.shuffle[0..1]
	    if fb_ids.length > 0
	      return buildings.random(shuffled_ids) unless searched_by == 'nyc'
	      Building.random(shuffled_ids)
	    end
	  end

	  def featured_building_ids ids, searched_by
	    fbs = FeaturedBuilding.active
	    fbs = fbs.where(building_id: ids) unless searched_by == 'nyc'
	    fbs.pluck(:building_id)
	  end
  end
end