# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.grid .row .box').click ->
    shape_id = $(this).attr('shape-id')
    $('#graphic_shape_id').val shape_id
    return
  $('.colors .row .box').click ->
    color_id = $(this).attr('color-id')
    $('#graphic_color_id').val color_id
    $('#graphic-form').submit()
    return
  return