# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

conn = ''

changecolor = (msgobj) ->
  console.log msgobj
  content = document.getElementById('shape-id-' + msgobj['shape_id'])
  content.style.backgroundColor = msgobj.clrcode
  return

window.onload = ->
  user_id = $('#graphic_user_id').val()
  webSocketUrl = 'ws://localhost:12345/chat?userid=' + user_id
  conn = new WebSocket(webSocketUrl)

  conn.onclose = (event) ->
    console.log 'Connection closed.'
    return

  conn.onmessage = (event) ->
    messages = event.data.split('\n')
    i = 0
    while i < messages.length
      msgobj = JSON.parse(messages[i])
      changecolor(msgobj);             
      i++
    return

  return

$(document).ready ->
  shape_id = ''
  user_id = ''
  color_id = ''
  $('.grid .row .box').click ->
    shape_id = $(this).attr('shape-id')
    user_id = $('#graphic_user_id').val()
    return
  $('.colors .row .box').click ->
    color_id = $(this).attr('color-id')
    if !conn
      return false
    message = JSON.stringify(
      user_id: Number(user_id)
      shape_id: Number(shape_id)
      color_id: Number(color_id))
    console.log message
    conn.send message
    false
  return
