module BuildingAmenities
	class << self
		def building_edit_emenities
			{
				no_fee: 								'No Fee Building',
				childrens_playroom: 		'Childrens Playroom',
				courtyard: 				 			'Courtyard',
				pets_allowed_cats: 			'Cats Allowed',
				pets_allowed_dogs: 			'Dogs Allowed',
				doorman: 								'Doorman',
				elevator: 							'Elevator',
				garage: 								'Garage',
				gym: 										'Gym',
				laundry_facility: 			'Laundry in Building',
				live_in_super: 					'Live in super',
				management_company_run: 'Management Company Run',
				parking: 								'Parking',
				roof_deck: 							'Roof Deck',
				swimming_pool: 					'Swimming Pool',
				walk_up: 								'Walk up'
			}
		end
		
		def all_amenities
			building_edit_emenities
		end

		# for filtering purpose
		def col1_popular_building_amenities
			{
				no_fee: 					 	'No Fee Building',
				pets_allowed_cats: 	'Cats Allowed',
				pets_allowed_dogs: 	'Dogs Allowed',
				doorman: 						'Doorman',
			}
		end

		def col2_popular_building_amenities
			{
				elevator: 					'Elevator',
				laundry_facility: 	'Laundry in Building',
				walk_up: 						'Walk up',
				courtyard: 					'Courtyard'
			}
		end

		def other_building_amenities
			{
				parking: 								'Parking/Garage',
				gym: 										'Gym',
				live_in_super: 					'Live in super',
				roof_deck: 							'Roof Deck',
				swimming_pool: 					'Swimming Pool'
			}
		end
	end
end