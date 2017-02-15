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

	#for Mobile vertical view search
	$(document).on 'click', '.searchIcon2',(e) ->
    	$('.mobile-search').toggleClass('hidden')