@flash = (content, type) ->
  type = 'alert' if !type?
  content = "<span class=\"alert alert-#{type}\">#{content}</span>"
  $('#flash').hide().html(content).fadeIn('slow').delay(3000).fadeOut('slow')
  

# manage flash messages after ajax queries
$(document).ajaxComplete (event, request) ->
  data = $.parseJSON(request.getResponseHeader('X-Message'))
  if data
    message = decodeURIComponent(escape(data.message))
    flash(message, data.type)