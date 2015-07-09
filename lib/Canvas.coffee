module.exports = class Canvas
  constructor: (confs={})->
    @width = confs.width or 0
    @height = confs.height or 0
    @left = confs.left or 0
    @top = confs.top or 0
    @data = confs.data or {}
    
    @forks = []
    
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
      strokeStyle: 'rgba(0,0,0,0)'
      textAlign: 'start'
      textBaseline: 'alphabetic'
    
    
    @el = document.createElement('canvas')
    @ctx = @el.getContext('2d')
    
    @applyStyles(@defaultStyles)
    
    @init()



  init: ->
    @el.setAttribute('width', "#{@width*pixelRatio}px")
    @el.setAttribute('height', "#{@height*pixelRatio}px")
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
    new Canvas({width:@width,height:@height,left:@left,top:@top,data:@data})
  
  
  export: ->
    JSON.stringify(@, ['width','height','left','top','data'])
  
  
  
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
    
    if @data.commands
      @parseCommands()
    



  parseCommands: ()->
    if @data.commands is undefined
      console.error("No commands found in canvas data")
      return


    for comm in @data.commands
      ref = if @forks.length then @forks[@forks.length - 1] else @
      s = window.performance.now()
      
      switch comm.command
        
        when 'add', 'subtract'
          ref.ctx.globalCompositeOperation = switch comm.command
            when 'add' then 'source-over'
            when 'subtract' then 'destination-out'

          ref.drawDataPoints(comm.data)
        
        when 'fill'
          ref.ctx.fillStyle = comm.data[4]
          ref.ctx.fillRect.apply(@ctx,comm.data)
        
        when 'fork'
          @forks.push(@clone())
        
        when 'merge'
          par = @forks[@forks.length - 2] or @
          par.ctx.drawImage(ref.el, 0, 0)
          @forks.splice(-1,1)[0].destroy()
        
        when 'setstyle'
          ref.applyStyles(comm.data)
        
        when 'reset'
          ref.applyStyles(@defaultStyles)
        
        when 'outline'
          c = ref.clone()
          c.ctx.drawImage(ref.el,0-comm.data[0],0)
          c.ctx.drawImage(ref.el,0-comm.data[0],comm.data[0])
          c.ctx.drawImage(ref.el,0,comm.data[0])
          c.ctx.drawImage(ref.el,comm.data[0],comm.data[0])
          c.ctx.drawImage(ref.el,comm.data[0],0)
          c.ctx.drawImage(ref.el,comm.data[0],0-comm.data[0])
          c.ctx.drawImage(ref.el,0,0-comm.data[0])
          c.ctx.drawImage(ref.el,0-comm.data[0],0-comm.data[0])
          
          c.ctx.fillStyle = comm.data[1]
          c.ctx.globalCompositeOperation = 'source-in'
          c.ctx.fillRect(0,0,@width,@height)          
          c.ctx.globalCompositeOperation = 'destination-out'
          c.ctx.drawImage(ref.el,0,0)
          
          
          #document.querySelector('.window').appendChild(c.el)
          #return
          
          ref.ctx.drawImage(c.el,0,0)   
          c.destroy()
        
        when 'inline'
          c = ref.clone()
          c.ctx.fillStyle = comm.data[1]
          c.ctx.fillRect(0,0,@width,@height)
          
          c.ctx.globalCompositeOperation = 'destination-out'
          c.ctx.drawImage(ref.el,0,0)
          
          cc = c.clone()
          
          cc.ctx.drawImage(c.el,0-comm.data[0],0)
          cc.ctx.drawImage(c.el,0-comm.data[0],comm.data[0])
          cc.ctx.drawImage(c.el,0,comm.data[0])
          cc.ctx.drawImage(c.el,comm.data[0],comm.data[0])
          cc.ctx.drawImage(c.el,comm.data[0],0)
          cc.ctx.drawImage(c.el,comm.data[0],0-comm.data[0])
          cc.ctx.drawImage(c.el,0,0-comm.data[0])
          cc.ctx.drawImage(c.el,0-comm.data[0],0-comm.data[0])
          
          cc.ctx.globalCompositeOperation = 'destination-in'
          cc.ctx.drawImage(ref.el,0,0)
          
          if comm.data[2]
            ref.ctx.save()
            ref.ctx.shadowBlur = comm.data[2]
            ref.ctx.shadowColor = comm.data[1]
          
          ref.ctx.drawImage(cc.el,0,0)
          
          if comm.data[2]
            ref.ctx.restore()
          
          cc.destroy()
          c.destroy()
      
      console.log(comm.command, window.performance.now()-s)


  destroy: ()->
    for f in @forks
      f.destroy()
    
    @forks.length = 0
    
    @el.parentNode.removeChild(@el) if @el.parentNode
    for own k,v of @
      delete @k


  drawDataPoints: (points)->    
    @ctx.beginPath()
    
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
      #@ctx.stroke()
      @ctx.fill()