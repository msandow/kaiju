if document.readyState is "complete"
  require('./Main.coffee')()
else
  window.onload = ->
    require('./Main.coffee')()
