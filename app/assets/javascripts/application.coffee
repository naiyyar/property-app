#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require contribute
#= require_tree .

jQuery ->
	$('.datepicker').datepicker({
		format: 'dd-mm-yyyy'
	});
	$('[data-toggle="popover"]').popover({ trigger: "hover" })

	$('input, textarea').placeholder()

	$(document).on 'click', '.left-side-zindex', (e) ->
		parentElem = $(this).parents().find('#leftSide')
		if(parentElem.hasClass('expanded'))
			parentElem.css('z-index', 999)