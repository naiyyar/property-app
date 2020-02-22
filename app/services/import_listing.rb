class ImportListing < ImportService

  def initialize file
    super
  end
  
  def create_listing building, listings, row, line_num
    listing = Listing.new
    listing.attributes            = row.to_hash
    listing[:building_id]         = building.id
    listing[:management_company]  = building.management_company.try(:name)
    if listing.save
      listing.update_rent(listings)
    else
      listing.errors.full_messages.each do |message|
        @errors << "Issue line #{line_num}, column #{message}."
      end
    end
  end

  def find_building buildings, address
    buildings  = buildings.where(building_street_address: address.strip)
    buildings  = buildings.where('building_street_address @@ :q', q: address) if buildings.blank?
    return buildings
  end

  def import_listings buildings, listings
    @errors = []
    (2..@spreadsheet.last_row).each do |i|
      row = Hash[[@header, @spreadsheet.row(i)].transpose ]
      if row['building_address'].present? and row['unit'].present? and row['date_active'].present?
        building = find_building(buildings, row['building_address'])
        if building.present?
          create_listing(building.first, listings, row, i)
        else
          @errors << "Issue line #{i}, Building address does not exist in database."
        end
      else
        @errors << "Issue line #{i}, #{missing_text_error_messages(row)} is missing."
      end
    end
    @errors
  end

  def missing_text_error_messages row
    missing_text = ''
    missing_text = 'Building address' if row['building_address'].blank?
    missing_text += ', Date active'   if row['date_active'].blank?
    missing_text += ', Unit'          if row['unit'].blank?
    return missing_text
  end
end