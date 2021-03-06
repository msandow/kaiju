gameConfigs = require('./Configs.coffee')
Utils = require('./Utilities.coffee')

module.exports = class
  constructor: (conf) ->
    @width = conf.width or 0
    @height = conf.height or 0
    @left = conf.left or 0
    @top = conf.top or 0
    
    @el = document.createElement('canvas')
    @ctx = @el.getContext('2d')
    @ratio = Utils.getPixelRatio(@ctx)
    
    @el.setAttribute('width', "#{@width*@ratio}px")
    @el.setAttribute('height', "#{@height*@ratio}px")
    @el.style.width = "#{@width}px"
    @el.style.height = "#{@height}px"
    
    @calculator = if conf.calculator then conf.calculator.bind(@) else (->).bind(@)
    @data = if conf.data then JSON.parse(JSON.stringify((conf.data))) else {}
    @data.doRender = true
    @renderer = if conf.renderer then conf.renderer.bind(@) else (->).bind(@)
    
    @


  build: ->
    s = new Date().getTime() if gameConfigs.debug
    @calculator()
    s = new Date().getTime() - s if gameConfigs.debug
    console.log("Calculating canvas took",s) if gameConfigs.debug and s

    if typeof @data.doRender is 'undefined' or !!@data.doRender
      s = new Date().getTime() if gameConfigs.debug
      @ctx.clearRect(0,0,@width,@height)
      @renderer()
      s = new Date().getTime() - s if gameConfigs.debug
      console.log("Rendering canvas took",s) if gameConfigs.debug and s


  destroy: ->
    @el.parentNode.removeChild(@el)
    delete @ctx
    delete @data
    delete @calculator
    delete @renderer
    delete @width
    delete @height
    delete @ratio
    delete @left
    delete @top