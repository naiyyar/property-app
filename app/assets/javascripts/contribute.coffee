$(document).on 'click', '#add_new_building',(e) ->
	e.preventDefault();
	$("#search-form").addClass('hide');
	$("#new_building").removeClass('hide');

$(document).on 'click', '#submit_review',(e) ->
	score = $("input[name='score']").val()
	reviewer_type = $('.reviewer_type').hasClass('active')
	residence_years = $("#review_stay_time option:selected").val()
	submit = false

	if(score == '')
		e.preventDefault();
		$(".rating-not-selected").removeClass('hide')
		submit = false
	else
		$(".rating-not-selected").addClass('hide')
		submit = true

	if(!reviewer_type)
		$(".status-not-selected").removeClass('hide')
		submit = false
	else
		$(".status-not-selected").addClass('hide')
		submit = true
	
	if(residence_years == '')
		if($(".reviewer_status:checked").val() != 'visitor')
			$(".years-not-selected").removeClass('hide')
			submit = false
	else
		$(".years-not-selected").addClass('hide')
		submit = true
	
	return submit

#To add validation on unit name when creating new unit on contribution page
#$(document).on 'click', '#unit_contribution_next_btn',(e) ->
#	elem = $("#unit_name").parent().find('.message')
#	if($("#unit_name").val() == '')
#		e.preventDefault()
#		elem.removeClass('hide')
#		return false
#	else
#		elem.addClass('hide')
#		return true

#Adding new unit contribution page
$(document).on 'click', '#add_new_unit',(e) ->
	e.preventDefault();
	$("#unit_id").val('');
	$("#unit_name").val('');
	$("#unit_square_feet").val('');
	$("#unit_number_of_bedrooms").val('');
	$("#unit_number_of_bathrooms").val('');
	$("#new_unit_building").removeClass('hide')
	$(".unit-search").addClass('hide');
	if($("#unit_name").parent().parent().hasClass('hide'))
		$("#unit_name").parent().parent().removeClass('hide')


$(document).on 'click', "input[name='contribute_to']",(e) ->
	user_id = $("#user_id").val();
	if(this.value=='unit_review' || this.value=='unit_photos' || this.value=='unit_amenities' || this.value=='unit_price_history')
		$("#next_btn").addClass('hide')
		$("#buildings-search-txt").val('')
		$("#buildings-search-no-results > li.no-result-li").hide()
		$("#unit_contribution").val(this.value)
		if(!$("#new_building").hasClass('hide'))
			$("#new_building").addClass('hide');
		#For new building creation
		$("#contribution").val(this.value)
		$("#new_building_submit").val('Submit')
		if($("#search-form").hasClass('hide'))
			$("#search-form").removeClass('hide')
			$("#buildings-search-txt").val('')
			$(".no-result-li").hide()
	else
		$("#search-form, #next_btn").removeClass('hide')
		$("#new_unit_building").addClass('hide')
		$("#new_building").addClass('hide');
		$(".building_contribution").val(this.value)
		if(this.value=='building_review')
			href = '/reviews/new'
		else if(this.value=='building_photos')
			if(user_id!='')
				href = '/uploads/new'
			else
				href = '/users/sign_in'

		$('#search_item_form').attr('action', href);

$(document).on 'click', '#elevator',(e) ->
	$('#building_elevator').toggleClass('hide')
	if($('#building_elevator').hasClass('hide'))
		$('#building_elevator').val('')

$(document).on 'click', '.reviewer_type',(e) ->
	id= $(this).children().attr('id')
	if(id == 'visitor')
		$("#review_stay_time").addClass('hide')
		$("#review_stay_time").next().hide()
		if($("#review_stay_time").data('validate'))
			$("#review_stay_time").removeAttr('data-validate')
	else
		$("#review_stay_time").removeClass('hide')
