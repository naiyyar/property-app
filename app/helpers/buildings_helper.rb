module BuildingsHelper
	SORT_INDEXES = ['1','2','3','4']

	def sort_options
		@sort_options ||= [	['Recently Updated', '0'],
			['Least Expensive - Listing', '1'],
			['Most Expensive - Listing', '2'],
			['Least Expensive - Building', '3'],
			['Most Expensive - Building', '4']
		]
	end

	def single_image(building)
		building.uploads.present? ? building.uploads.last.image.url : Building::NO_PHOTO
	end

	def disabled(current_user, val)
		val.present? && current_user && !current_user.has_role?(:admin)
	end

	def contribute_left_side params
		'contributeLeftSide' if contribution?(params)
	end

	def contribute_wrapper params
		'contribute-wrapper' if contribution?(params)
	end

	def contribution? params
		action_name == 'contribute' || params[:contribution].present?
	end

	def date_uploaded object
		"<b>#{ associated_object(object.imageable) }</b>" +
		"<p>Date uploaded: #{ object.created_at.strftime('%m/%d/%Y') }</p>" +
		"<p>" + fancybox_cta_buttons(object.imageable) + "</p>".html_safe
	end

	def fancybox_cta_buttons imageable
		if imageable.class.name == 'FeaturedListing'
			featured_listing_contact_owner_button(imageable, size_class: 'txt-color-white btn-slider')
		else
			imageable && imageable.class.name == 'Building' ? show_slider_cta_links(imageable) : ''
		end
	end

	def sort_string
		return 'Recently updated' unless SORT_INDEXES.include?(params[:sort_by])
		sort_options[params[:sort_by].to_i][0]
	end

	def set_ranges building_price, price
		if building_price == 1
      "#{number_to_currency(price.max_price, precision: 0)} <"
    elsif building_price == 2 || building_price == 3
      "#{number_to_currency(price.min_price, precision: 0)} - #{number_to_currency(price.max_price, precision: 0)}"
    elsif building_price == 4
      "#{number_to_currency(price.min_price, precision: 0)} +"
    else
    	"#{number_to_currency(0, precision: 0)} - #{number_to_currency(0, precision: 0)}"
    end
	end

	def set_bed_ranges building, filters = nil
		if building.prices.present? || building.show_bed_ranges(filters).present?
	    (price_col(building, filters).to_s + types_col(building, filters).to_s).html_safe
	  end
	end

	def price_col b, filters
		if b.min_and_max_price? && show_price_range_with_filters?(b, filters)
			"<b> #{min_and_max_prices(b, filters)} </b>"
		elsif b.min_and_max_price? && b.min_listing_price > 0
			"<b> #{min_and_max_prices(b, filters)} </b>"
		else
			"<span> #{b.prices} </span>"
		end
	end

	def show_price_range_with_filters?(b, filters)
		filters.present? && b.min_listing_price > 0
	end

	def min_and_max_prices prop, filters
    if prop.min_and_max_price? && filters.blank?
  		return number_to_currency(prop.min_listing_price, precision: 0) if prop.min_listing_price == prop.max_listing_price
  		"#{number_to_currency(prop.min_listing_price, precision: 0)} - #{number_to_currency(prop.max_listing_price, precision: 0)}"
  	else
  		return number_to_currency(prop.min_price, precision: 0) if prop.min_price == prop.max_price
  		"#{number_to_currency(prop.min_price, precision: 0)} - #{number_to_currency(prop.max_price, precision: 0)}"
  	end
  end

  def types_col b, filters
		"<span> #{'|' if b.show_bed_ranges(filters).present?} #{b.show_bed_ranges(filters).join(', ')} </span>" +
		"#{with_bed_text(b, filters)}"
	end

	def with_bed_text b, filters
		return '' if b.has_only_studio?(filters) || b.has_only_room?(filters) || b.coliving?
		"#{'Bed' if b.bedroom_types? || (b.listings_count > 0)}"
	end

	def nearby_link_text nb
		case nb
		when 'Midtown'
			"Midtown NYC #{apt_rent_text}"
		when 'Corona'
			"Corona NY #{apt_rent_text}"
		when 'Flatiron Distric'
			"Flatiron #{apt_rent_text}"
		else
			"#{nb} #{apt_rent_text}"
		end
	end

	def apt_rent_text
		'Apartments For Rent'
	end
end
