gameConfigs = require('./Configs.coffee')
Utils = require('./Utilities.coffee')
StaticCanvas = require('./StaticCanvas.coffee')


loadImage = (src, cb)->
  id = src.split("/")
  id = id.slice(id.length-2)

  if src.indexOf('?') > -1
    src += '&v='+gameConfigs.version
  else
    src += '?v='+gameConfigs.version

  img = document.createElement('img')
  img.style.display = 'none'
  img.onload = ->
    can = StaticCanvas(
      width: img.width
      height: img.height
      renderer: ->
        @ctx.drawImage(img,0,0)
    )
    
    can.style.display = 'none'
    document.body.appendChild(can)
    img.parentNode.removeChild(img)
    can.id = Utils.stringToID(id.join("-"))
    cb()
  
  document.body.appendChild(img)
  img.src = src
  img

isImageFile = (src)->
  /\.(jpg|jpeg|bmp|gif|png|tiff|svg)/i.test(src)

module.exports = (resources, cb)->
  loadedImages = 0
  
  for item in resources
    if isImageFile(item)
      loadImage(item, ()->
        loadedImages++
        
        if loadedImages is resources.length
          cb()
      )