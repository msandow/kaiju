Utils = require('./Utilities.coffee')

module.exports = class
  constructor: (conf) ->
    @width = conf.width or 0
    @height = conf.height or 0
    @left = conf.left or 0
    @top = conf.top or 0
    
    @el = document.createElement('canvas')
    @ctx = @el.getContext('2d')
    @ctx.imageSmoothingEnabled = false
    @ratio = Utils.getPixelRatio(@ctx)
    
    @el.setAttribute('width', "#{@width*@ratio}px")
    @el.setAttribute('height', "#{@height*@ratio}px")
    @el.style.width = "#{@width}px"
    @el.style.height = "#{@height}px"
    
    @calculator = if conf.calculator then conf.calculator.bind(@) else (->).bind(@)
    @data = if conf.data then JSON.parse(JSON.stringify((conf.data))) else {}
    @renderer = if conf.renderer then conf.renderer.bind(@) else (->).bind(@)
    
    @


  build: ->
    @calculator()

    if typeof @data.doRender is 'undefined' or !!@data.doRender
      @ctx.clearRect(0,0,@width,@height)
      @renderer()
      console.log('render')


  destroy: ->
    @el.parentNode.removeChild(@el)
    @ctx = null
    @calculator = (->)
    @renderer = (->)