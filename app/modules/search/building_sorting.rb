module Search
  module BuildingSorting
    def sort_buildings(buildings, sort_params, filters = {})
      # 0 => Default by active listings
      #1.Least Expensive - Listing
        #Sort by lowest listing price available at building with the building with the lowest price displayed at the top
      #2.Most Expensive - Listing
        #Sort by highest listing price available at building with the building with the highest price displayed at the top
      #3.Least Expensive - Building
        #1st sort by dollar sign at the building with the building with the lowest dollar sign displayed at the top
        #2nd sort by Buildings with Active Listings
        #3rd sort by alphabetical A-Z
      #4.Most Expensive - Building
        #1st sort by dollar sign at the building with the building with the highest dollar sign displayed at the top
        #2nd sort by Buildings with Active Listings
        #3rd sort by alphabetical A-Z

      return buildings unless sort_params.present?
      
      buildings = case sort_params
                  when '1'
                    buildings = buildings.where(id: (sorted_building_ids_by_min_price(buildings)))
                    return least_exp_sorted_buildings(buildings) if filters.present? && has_listing_filters?(filters.keys)
                    buildings.order_by_min_rent
                  when '2'
                    buildings = buildings.where(id: (sorted_building_ids_by_max_price(buildings)))
                    return most_exp_sorted_buildings(buildings) if filters.present? && has_listing_filters?(filters.keys)
                    buildings.order_by_max_rent
                  when '3'
                    buildings.where(id: sorting_buildings_ids(buildings)).order_by_min_price
                  when '4'
                    buildings.order('price DESC NULLS LAST, 
                                     listings_count DESC, 
                                     building_name ASC, 
                                     building_street_address ASC')
                  else
                    return sorted_by_recently_updated(buildings) if filters.present? && has_listing_filters?(filters.keys)
                    buildings.updated_recently
                  end
      
      buildings
    end

    def sorted_by_recently_updated buildings
      sorted_buildings_by(buildings.pluck(:id).uniq)
    end

    def least_exp_sorted_buildings buildings
      sorted_buildings_by(sorted_building_ids_by_rent(buildings, 'ASC'))
    end

    def sorted_buildings_by ids
      # Building.where(id: ids.uniq) #.sort_by{|p| ids.index(p.id)}.uniq{|b| b.id }
      transparentcity_buildings.order_by_id_pos(ids)
    end

    def most_exp_sorted_buildings buildings
      sorted_buildings_by(sorted_building_ids_by_rent(buildings, 'DESC'))
    end

    def sorted_building_ids_by_rent buildings, sort_type
      buildings.joins(:listings)
              .select('listings.rent, buildings.*')
              .reorder("listings.rent #{sort_type}")
              .map(&:id).uniq
    end

    def has_listing_filters? keys
      keys.include?('listing_bedrooms') || keys.include?('min_price')
    end

    # 1.Least Expensive - Listing
    def sorted_building_ids_by_min_price buildings
      ids_arr = []
      filtered_buildings = where(id: buildings.pluck(:id))
      ids_arr += filtered_buildings.where.not(min_listing_price: nil)
                                   .with_active_listing
                                   .order_by_min_rent
                                   .map(&:id)
      ids_arr += buildings.where(min_listing_price: nil).pluck(:id)
      return ids_arr
    end

    # 2.Most Expensive - Listing
    def sorted_building_ids_by_max_price buildings
      ids_arr = []
      filtered_buildings = where(id: buildings.pluck(:id))
      ids_arr += filtered_buildings.where.not(max_listing_price: nil)
                                   .with_active_listing
                                   .order_by_max_rent
                                   .map(&:id)
      ids_arr += buildings.where(max_listing_price: nil).pluck(:id)
      return ids_arr
    end

    # 3.Least Expensive - Building
    def sorting_buildings_ids buildings
      ids_arr = []
      filtered_buildings = where(id: buildings.pluck(:id))
      ids_arr += filtered_buildings.where.not(price: nil)
                                   .order_by_min_price
                                   .map(&:id)
      ids_arr += buildings.where(price: nil).pluck(:id)
      return ids_arr
    end
  end
end