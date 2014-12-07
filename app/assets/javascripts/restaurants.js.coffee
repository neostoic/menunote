# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
	$('.menu_sections').change ->
		$.ajax '/',
		  type: '/GET',
		  error: (e) ->	console.log e,
		  success: (res) -> console.log "Card name: " + data,
		  complete: (jqXHR, textStatus) -> console.log "Status: " + textStatus

