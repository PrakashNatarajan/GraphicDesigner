# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


do ->
  $(document).on 'click', '.toggle-window', (e) ->
    e.preventDefault()
    panel = $(this).parent().parent()
    messages_list = panel.find('.messages-list')
    panel.find('.panel-body').toggle()
    panel.attr 'class', 'panel panel-default'
    if panel.find('.panel-body').is(':visible')
      height = messages_list[0].scrollHeight
      messages_list.scrollTop height
    return
  return