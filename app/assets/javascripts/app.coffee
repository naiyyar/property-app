jQuery ->
	#from uploads/index page
	$(document).on 'click', '.delete_image',(e) ->
		$(this).parent().hide(500);
	
	$('[data-toggle="tooltip"]').tooltip();

	#removing hash after facebook login
	if(window.location.hash && window.location.hash == '#_=_')
    window.location.hash = ''

	$('input, textarea').placeholder()

	#using to open property show page on infowindow click
	$(document).on 'click', '.infoW-property-info', (e) ->
		url = $(this).data('href')
		window.location.href = url
	
	$(document).on 'click', '.left-side-zindex', (e) ->
		parentElem = $(this).parents().find('#leftSide')
		if(parentElem.hasClass('expanded'))
			parentElem.css('z-index', 999)

	window.setTimeout (->
   	$('.alert').slideUp 300, ->
     	$(this).remove()
 	), 1000

ready = ->
	$('[data-toggle="tooltip"]').tooltip({ trigger: 'click' })

	$('.datepicker').datepicker
		format: 'yyyy-mm-dd'

	$('.datepicker').on 'changeDate',(e) ->
		$(this).datepicker('hide')

$(document).ready(ready)
$(document).on('page:load', ready)