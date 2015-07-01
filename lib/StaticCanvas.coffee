CanvasBase = require('./CanvasBase.coffee')

_static = class extends CanvasBase
  constructor: (conf)->
    super(conf)
    
    @el.style.display = "none"
    document.body.appendChild(@el)
    @build()
    @el

module.exports = (conf)->
  new_static = new _static(conf)
  new_static.el