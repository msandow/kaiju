
module.exports = class Canvas
  constructor: (confs={})->
    @width = confs.width or 0
    @height = confs.height or 0
    @left = confs.left or 0
    @top = confs.top or 0
    @data = confs.data or {}
    @opacity = if typeof confs.opacity isnt undefined then confs.opacity else 1
    
    @defaultStyles = 
      fillStyle: '#000'
      font: '10px sans-serif'
      globalAlpha: 1
      globalCompositeOperation: 'source-over'
      lineCap: 'butt'
      lineDashOffset: 0
      lineJoin: 'miter'
      lineWidth: 1
      miterLimit: 1
      shadowBlur: 0
      shadowColor: 'rgba(0,0,0,0)'
      shadowOffsetX: 0
      shadowOffsetY: 0
      strokeStyle: 'rgba(0,0,0,1)'
      textAlign: 'start'
      textBaseline: 'alphabetic'
    
    
    @el = document.createElement('canvas')
    @ctx = @el.getContext('2d')
    
    @applyStyles(@defaultStyles)
    
    @init()



  init: ->
    @el.setAttribute('width', "#{@width*pixelRatio}px")
    @el.setAttribute('height', "#{@height*pixelRatio}px")
    @el.style.opacity = @opacity
    @el.style.width = "#{@width}px"
    @el.style.height = "#{@height}px"
    @el.style.left = "#{@left}px"
    @el.style.top = "#{@top}px"


  getPixelAlpha: (x,y)->
    return false if x >= @width or y >= @height
    @ctx.getImageData(x,y,1,1).data[3]


  applyStyles: (styles)->
    for own k, v of styles
      @ctx[k] = v


  clear: ()->
    @ctx.clearRect(0,0,@width,@height)
    @

  
  
  drawCircle: (x,y,rad)->
    @ctx.arc(x, y, rad, 0, 2 * Math.PI, false)
    @

  
  
  exec: (cb)->
    cb.call(@)
    @
    
    
  clone: ()->
    new Canvas({width:@width,height:@height,left:@left,top:@top,data:@data,opacity:@opacity})


  destroy: ()->
    @el.parentNode.removeChild(@el) if @el.parentNode
    for own k,v of @
      delete @k

