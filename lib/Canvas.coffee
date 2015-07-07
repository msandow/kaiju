module.exports = class Canvas
  constructor: (confs={})->
    @width = confs.width or 0
    @height = confs.height or 0
    @left = confs.left or 0
    @top = confs.top or 0
    @data = confs.data or {}

    @el = document.createElement('canvas')
    @ctx = @el.getContext('2d')
    @init()



  init: ->
    @el.setAttribute('width', "#{@width*pixelRatio}px")
    @el.setAttribute('height', "#{@height*pixelRatio}px")
    @el.style.width = "#{@width}px"
    @el.style.height = "#{@height}px"
    @el.style.left = "#{@left}px"
    @el.style.top = "#{@top}px"
  
  clear: ()->
    @ctx.clearRect(0,0,@width,@height)
    @

  
  
  drawCircle: (x,y,rad)->
    @ctx.arc(x, y, rad, 0, 2 * Math.PI, false)
    @

  
  
  exec: (cb)->
    cb.call(@)
    @
    
    
  export: ->
    JSON.stringify(@)
  
  
  
  import: (o)->
    if typeof o is 'string'
      o = JSON.parse(o)
    
    @width = o.width or 0
    @height = o.height or 0
    @left = o.left or 0
    @top = o.top or 0
    @data = o.data or {}
    
    @init()
    
    for own k,v of o
      delete o[k]
    



  parseCommands: ()->
    if @data.commands is undefined
      console.error("No commands found in canvas data")
      return
    
    @ctx.save()
    
    for comm in @data.commands
      @ctx.globalCompositeOperation = switch comm.command
        when 'add' then 'source-over'
        when 'subtract' then 'destination-out'

      @drawDataPoints(comm.data)
    
    @ctx.restore()



  destroy: ()->
    @el.parentNode.removeChild(@el)
    for own k,v of @
      delete @k


  drawDataPoints: (points)->
    @ctx.beginPath()
    #@ctx.lineWidth = 3
    
    if points.length

      @ctx.moveTo(points[0][0], points[0][1])
    
      p = 0

      while p < points.length
        left = points.length - p

        if left is 1
          @ctx.lineTo(points[p][0], points[p][1])
          p += 1
        else if left is 2
          @ctx.quadraticCurveTo(points[p][0], points[p][1], points[p+1][0], points[p+1][1])
          p += 2
        else if left >= 3
          @ctx.bezierCurveTo(points[p][0], points[p][1], points[p+1][0], points[p+1][1], points[p+2][0], points[p+2][1])
          p += 3
      
      @ctx.closePath()
      @ctx.fillStyle = '#000'
      @ctx.fill()
      #@ctx.strokeStyle = 'black'
      #@ctx.stroke()