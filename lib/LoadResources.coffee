Configs = require('./Configs.coffee')
Canvas = require('./Canvas.coffee')

loadImage = (src, cb)->
  if src.indexOf('?') > -1
    src += '&v='+Configs.VERSION
  else
    src += '?v='+Configs.VERSION

  img = document.createElement('img')
  img.style.display = 'none'
  
  img.addEventListener('load', ()->
    can = new Canvas(
      width: img.width
      height: img.height
    )

    can.exec(->
      @ctx.fillRect(0,0,@width,@height)
      @ctx.drawImage(
        img,
        0,
        0,
        @width,
        @width,
        0,
        0,
        @width*Configs.PIXEL_RATIO,
        @height*Configs.PIXEL_RATIO
      )
    )
    
    can.el.style.display = 'none'
    document.body.appendChild(can.el)
    img.parentNode.removeChild(img)
    cb(can)
  )
  
  document.body.appendChild(img)
  img.src = src
  img

isImageFile = (src)->
  /\.(jpg|jpeg|bmp|gif|png|tiff|svg)/i.test(src)

module.exports = (resources, cb)->
  loadedImages = Object.keys(resources).length
  
  for own k,v of resources
    do (k, v)->
      if isImageFile(v)
        loadImage(v, (can)->
          loadedImages--
          resources[k] = can
          
          cb(resources) if !loadedImages
        )
