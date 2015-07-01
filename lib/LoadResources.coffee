gameConfigs = require('./Configs.coffee')

loadImage = (src, cb)->
  if src.indexOf('?') > -1
    src += '&v='+gameConfigs.version
  else
    src += '?v='+gameConfigs.version
  
  img = document.createElement('img')
  img.style.display = 'none'
  img.onload = cb
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