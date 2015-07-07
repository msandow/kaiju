Main = require('./Main.coffee')

if document.readyState is "complete"
  Main()
else
  window.onload = Main