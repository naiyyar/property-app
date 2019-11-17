module BuildingsHelper
	def rating_for_user(rateable_obj, rating_user, dimension = nil, options = {})
	  star = options[:star] || 5
	   #readonly = true
	  if rating_user.present?
		  @object = rateable_obj
		  @user = rating_user
		  review_id = options[:review_id] || nil
		  @rating = Rate.find_by_rater_id_and_rateable_id_and_dimension_and_review_id(@user.id, @object.id, dimension,review_id)
		  stars = @rating ? @rating.stars : 0

		  disable_after_rate = options[:disable_after_rate] || false
		  target       = options[:target]       || ''
	    targetText   = options[:targetText]   || ''
	    targetType   = options[:targetType]   || 'hint'
	    targetFormat = options[:targetFormat] || '{score}'
	    targetScore  = options[:targetScore]  || ''

		  if disable_after_rate
		    readonly = rating_user.present? ? !rateable_obj.can_rate?(rating_user, dimension) : true
		  end

		  content_tag :div, '', "data-dimension" => dimension, :class => "star", "data-rating" => stars,
		  "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
		  "data-disable-after-rate" => disable_after_rate,
		  "data-readonly" => readonly,
		  "data-star-count" => star,
      "data-target" => target,
      "data-target-text" => targetText,
      "data-target-format" => targetFormat,
      "data-target-score" => targetScore
		else
			content_tag :div, '', "data-dimension" => dimension, :class => "star", "data-rating" => 0,
		  "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
		  "data-disable-after-rate" => disable_after_rate,
		  "data-readonly" => readonly,
		  "data-star-count" => star
		end
	end

	def imageable upload
		if upload.imageable.present?
			if upload.imageable_type == 'Building'
				upload.imageable.building_name
			elsif upload.imageable_type == 'Unit'
				upload.imageable.name
			else
				''
			end
		end
	end

	def reviewable_path review
		 if review.reviewable_object.kind_of? Building
      building_path(review.reviewable_object)
    elsif review.reviewable_object.kind_of? Unit
      unit_path(review.reviewable_object)
    end
	end

	def building_name_or_address building
		building.building_name.present? ? building.building_name : building.building_street_address
	end

	def single_image(building)
		building.uploads.present? ? building.uploads.last.image.url : 'no-photo-available.jpg'
	end

	def contribution? params
		action_name == 'contribute' || params[:contribution].present?
	end

	def disabled(current_user, val)
		if val.present? && current_user && !current_user.has_role?(:admin)
			true
		end
	end

	def contribute_left_side params
		if contribution?(params)
			'contributeLeftSide'
		end
	end

	def contribute_wrapper params
		if contribution?(params)
			'contribute-wrapper'
		end
	end

	def building_amenities
		{
			no_fee: 'No Fee Building',
			childrens_playroom: 'Childrens Playroom',
			courtyard: 'Courtyard',
			pets_allowed_cats: 'Cats Allowed',
			pets_allowed_dogs: 'Dogs Allowed',
			doorman: 'Doorman',
			elevator: 'Elevator',
			garage: 'Garage',
			gym: 'Gym',
			laundry_facility: 'Laundry in Building',
			live_in_super: 'Live in super',
			management_company_run: 'Management Company Run',
			parking: 'Parking',
			roof_deck: 'Roof Deck',
			swimming_pool: 'Swimming Pool',
			walk_up: 'Walk up'
		}
	end

	def listing_amenities
		{
			months_free_rent: 'Months Free Rent',
			owner_paid: 'Owner Paid',
			rent_stabilized: 'Rent Stabilized'
		}
	end

	def recommended_percent object
		thumb_icon = "| <span class='fa fa-thumbs-up recommended'></span>"
		recommended = ''
		if object.present? and object.recommended_percent.present?
			rec_percent = object.recommended_percent
			if rec_percent.nan? 
				recommended = "#{thumb_icon} --%"
			elsif rec_percent == 0
				recommended = "#{thumb_icon} 0%"
			else
				recommended = "#{thumb_icon} #{rec_percent.to_i}%"
			end
		end
		"#{recommended} &nbsp; | Reviews: #{object.reviews_count.to_i}"
	end

	def prices_options
		[
			['$', 1],
			['$$', 2],
			['$$$', 3],
			['$$$$', 4]
		]
	end

	def heart_icon
		'<span class="fa fa-heart"></span>'.html_safe
	end

	def heart_link object, user
		#To save as favourite sending js request
		#to unsave as favourite sending json request
		@current_user = current_user.present? ? current_user : user
		link_to heart_icon, saved_object_url(object), 
												remote: remote(object), class: fav_classes(object), 
												title: heart_link_title(object), 
												data: { objectid: object.id }, 
												method: :post
	end

	def fav_classes object
		"favourite save_link_#{object.id} #{saved_color_class(object)}"
	end

	def remote object
		(object.favorite_by?(@current_user) ? false : true )
	end

	def saved_object_url object
		object.favorite_by?(@current_user) ? 'javascript:;' : favorite_path(object_id: object.id)
	end

	def heart_link_title(object)
		(@current_user.present? and object.favorite_by?(@current_user)) ? 'Unsave' : 'Save'
	end

	def saved_color_class(object)
		(@current_user.present? and object.favorite_by?(@current_user)) ? 'filled-heart' : 'unfilled-heart'
	end

	def check_availability_link building, sl_class=nil
		if building.active_web_url?
			bt_block_class = sl_class.present? ? sl_class : 'btn-block'
      link_to 'Check Availability', building.web_url, 
      														onclick: "window.open(this.href,'_blank');return false;",
      														class: "btn #{bt_block_class} btn-primary txt-color-white font-bolder",
      														style: "padding: #{bt_block_class.include?('btn-xs') ? '8px 0px' : ''}"
    else
      link_to check_availability, building_url(building), class: 'btn btn-block btn-primary invisible'
    end
	end

	def check_availability_button web_url, klass
		link_to 'Check Availability', web_url, 
																	onclick: "window.open(this.href,'_blank');return false;",
																	class: "btn btn-primary #{klass}"
	end

	def contact_leasing_button building, event, klass
		title, classes = 'Contact Leasing', "btn btn-primary #{klass}"
		unless event
			link_to title, 'javascript:;', data: { bid: building.id, type: 'contact' }, class: classes
		else
			link_to title, 'javascript:;', onclick: "showLeasingContactPopup(#{building.id})", class: classes
		end
	end

	def active_listings_button building, event, klass
		title, classes = 'Active Listings', "btn btn-primary active-listing-link #{klass}"
		unless event
			link_to title, 'javascript:;', data: { bid: building.id, type: 'listings' }, class: classes
		else
			link_to title, 'javascript:;', onclick: "showActiveListingsPopup(#{building.id})", class: classes
		end
	end

	def check_availability
		'<b>Check Availability</b>'.html_safe
	end

	def date_uploaded object
		"<b>#{ associated_object(object.imageable) }</b>" +
		"<p>Date uploaded: #{ object.created_at.strftime('%m/%d/%Y') }</p>" +
		"<p>" + check_availability_link(@building, 'btn-slider') + "</p>".html_safe if @building.present?
	end

	def sort_options
		[	['Recently Updated', '0'],
			['Least Expensive - Listing', '1'],
			['Most Expensive - Listing', '2'],
			['Least Expensive - Building', '3'],
			['Most Expensive - Building', '4']
		]
	end

	def sort_string
		if ['1','2','3','4'].include?(params[:sort_by])
			sort_options[params[:sort_by].to_i][0]
		else
			'Recently updated'
		end
	end

	def set_ranges building_price, price
		if building_price == 1
      "#{number_to_currency(price.max_price, precision: 0)} <"
    elsif building_price == 2 or building_price == 3
      "#{number_to_currency(price.min_price, precision: 0)} - #{number_to_currency(price.max_price, precision: 0)}"
    elsif building_price == 4
      "#{number_to_currency(price.min_price, precision: 0)} +"
    end
	end

end