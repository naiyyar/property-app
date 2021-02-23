module LinksHelper
	def append_tour_link tourable, category, last_tour:nil
		tourable_type = tourable.class.name
		link_to add_video_text(tourable_type), 
						new_video_tour_path(category: category, 
																tourable_id: tourable.id, 
																tourable_type: tourable_type, 
																sort_index: sort_num(last_tour)), 
						class: 'add-tour-form', remote: true
	end

	def add_video_text(tourable_type)
		if tourable_type == 'Building'
			plus_icon
		else
			"Add Video #{plus_icon}".html_safe
		end
	end

	def sort_num last_tour
		last_tour.present? ? last_tour.sort + 1 : 0
	end

	def renew_switch_button object, disabled: false
		disabled_class = disabled ? 'disabled' : ''
		checked = object.renew ? 'checked' : ''
		return "<input type='checkbox' 
						class='#{switch_button_classes} renew #{disabled_class} #{object_class(object)}' 
						style='margin: 0px;' 
						data-field='renew'
						data-fbid=#{object.id} 
						#{checked} #{disabled_class} />".html_safe
	end

	def active_switch_button object, fbby: '', showbillingurl: false
		checked = object.active ? 'checked' : ''
		return "<input type='checkbox' 
						class='#{switch_button_classes} #{object_class(object)}' 
						style='margin: 0px;' 
						data-fbid=#{object.id} 
						data-fbby='#{fbby}'
						data-expired=#{object.expired? ? 'expired' : ''}
						data-billingurl=#{billing_url(object) if showbillingurl }
						#{checked} />".html_safe
	end

	def switch_button_classes
		'apple-switch sb-sm'
	end

	def object_class object
		object.class.name.split(/(?=[A-Z])/).join('-').downcase rescue ''
	end

	def billing_url object
		return '' unless object.expired?
 		
 		case object.class.name
		when 'FeaturedListing'
			next_prev_step_url(object, step: 'payment')
		when 'FeaturedAgent'
			new_manager_featured_agent_user_path(current_user, type: 'billing', object_id: object.id)
		when 'FeaturedBuilding'
			new_manager_featured_building_user_path(current_user, type: 'billing', object_id: object.id)
		end
	end

	def previous_link url
		site_link_h(text: '← Previous', 
								url: url, 
								klasses: "#{action_btn_classes} btn-o font-bold", 
								style: action_link_styles)
	end

	def next_link url
		site_link_h(text: next_text, 
								url: url, 
								klasses: "#{action_btn_classes} font-bold", 
								style: action_link_styles)
	end

	def done_link url
		site_link_h(text: 'Done', 
							  url: url, 
							  klasses: "#{action_btn_classes} btn-done font-bold",
							  style: action_link_styles)
	end

	def cancel_link url
		site_link_h(text: 'Cancel', url: url, klasses: "cancel #{btn_default_h} #{font_size16_h} font-bold")
	end

	def submit_link form, title:'Submit', disabled: false
		form.submit title, 
								class: 'btn btn-primary font-16 pl-28 pr-28 font-bold', 
								disabled: disabled, 
								style: action_link_styles
	end

	def next_text
		'Next →'
	end

	def neighborhood_link nb, target: ''
		nb = 'Midtown' if nb == 'Midtown Manhattan'
		return '' if nb.blank?
    search_by_neighborhood_link(nb, 'MANHATTAN', target: target,  show_count: false) 
	end

	def search_by_neighborhood_link nb, area, target: '' , show_count: true
		link_to search_link(nb, area), target: target, data: { nbname: nb, st: searchable_text(nb, area) } do
			if show_count
				neighborhood = @pop_nb_hash[nb]
				if neighborhood.present?
					"#{nb} (<span>#{neighborhood[0].buildings_count}</span>)".html_safe
				else
					"#{nb} (#{parent_neighborhoods_count(nb)})"
				end
			else
				nb
			end
		end
	end

	def action_link_styles
		"width: #{browser.device.mobile? ? '8em' : '10em'};"
	end

	def action_links_alignment_class
		browser.device.mobile? ? 'text-center' : 'text-right'
	end

	def site_link_h text: '', url: '#', klasses: '', style: ''
		link_to text, url, class: klasses, style: style
	end

	def action_btn_classes
		"btn btn-primary #{font_size16_h} pl-28 pr-28"
	end

	def font_size16_h
		'font-16'
	end

	def btn_default_h
		'btn btn-default'
	end
end