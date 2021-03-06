module BedRanges
  MONTHS_IN_YEAR = 12
  
  def price_ranges filters=nil
    ranges = {}
    prices = Price.where(range: price)
    bed_ranges, modal_type = bedroom_ranges(filters)
    bed_ranges.each do |bed_range|
      bdr = bed_range
      bdr = Building::COLIVING_NUM if bed_range == -1 && modal_type == 'listing'
      ranges[bed_range] = prices.find_by(bed_type: bdr)
    end
    return ranges
  end

  def broker_fee_savings
    saved_amounts = {}
    rent_median_prices.as_json.each do |mp| 
      saved_amounts[mp['bed_type']] = (((mp['price'].to_i * MONTHS_IN_YEAR) * broker_percent)/100).to_i
    end
    saved_amounts
  end

  def rent_median_prices
    range = bedroom_ranges[0]
    if range.include?(-1)
      range = range.map{|x| x == -1 ? Building::COLIVING_NUM : x }
    end
    return rent_medians.where(range: price, bed_type: range)
  end

  def broker_percent
    @broker_percent ||= BrokerFeePercent.first.percent_amount
  end

  def rent_medians
    @rent_medians ||= RentMedian.all
  end

  def min_and_max_price?
    min_listing_price.present? && max_listing_price.present?
  end

  def min_save_amount
    broker_fee_savings.values.min
  end

  def has_only_studio? filters
    show_range = show_bed_range(filters)
    return show_range.length == 1 && show_range[0] == 'Studio'
  end

  def has_only_room? filters
    show_range = show_bed_range(filters)
    return show_range.length == 1 && show_range[0] == 'Room'
  end

  def show_bed_range filters
    @show_bed_range ||= show_bed_ranges(filters)
  end

  def show_bed_ranges(filter_params)
    bed_ranges, modal_type = bedroom_ranges(filter_params)
    return bed_ranges.map{|bed| set_bed_type(bed, modal_type)}
  end

  def set_bed_type bed, modal_type
    return 'Room' if bed == -1
    return 'Studio' if bed == 0
    return 'CoLiving' if bed == Building::COLIVING_NUM && modal_type == 'building'
    bed
  end

  def bedroom_ranges(filter_params=nil)
    unless min_and_max_price?
      return building_beds, 'building'
    else
      return get_listings_beds(filter_params), 'listing'
    end
  end

  def building_beds
    bedroom_types.keep_if{|val| !val.empty?}.map(&:to_i) rescue []
  end

  def get_listings_beds filter_params
    listings = act_listings.present? ? act_listings : self.get_listings(filter_params)
    return listings&.pluck(:bed).uniq.compact.sort
  end

  def coliving_with_building_beds?
    !listings_beds? && coliving?
  end

  def listings_beds?
    min_and_max_price?
  end

  def bedroom_types?
    building_beds.present?
  end

  def coliving?
    building_beds.include?(Building::COLIVING_NUM)
  end
end