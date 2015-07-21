# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  # Toggles the advanced search form on the index page
  $(".search-toggle").click ->
    $("#search-form").slideToggle()

  # Makes the sides form only display by default on opp choice cases
  if $(".opp-choice-checkbox").is(":checked")
    $("#sides").show()
  else
    $("#sides").hide()

  # Toggles the sides form when a case is made opp choice
  $(".opp-choice-checkbox").click ->
    $("#sides").slideToggle()
