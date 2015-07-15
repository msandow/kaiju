Configs = require('./Configs.coffee')
Canvas = require('./Canvas.coffee')
URL = require('./StaticMap.coffee')

greenScreen = (can)->
  imageData = can.ctx.getImageData(0, 0, can.width, can.height)
  data = imageData.data

  p = 0
  while p < data.length
    data[p + 3] = 255 - data[p + 1]
    data[p + 1] = 0

    p += 4

  can.ctx.putImageData(imageData, 0, 0)


loader = (tiles, style, cb) ->
  can = new Canvas(
    width: tiles.width * Configs.TILE_SIZE
    height: tiles.height * (Configs.TILE_SIZE - Configs.CROP)
  )
  
  can.el.style.display = "none"
  
  counter = tiles.cells.length  
  
  for tile in tiles.cells
    do (tile)->
      img = document.createElement('img')
      
      img.width = Configs.TILE_SIZE
      img.height = Configs.TILE_SIZE

      img.style.display = "none"
      img.crossOrigin = ""
      
      img.addEventListener('load', ()->
        can.exec(->
          @ctx.drawImage(
            img
            0
            0
            Configs.TILE_SIZE
            Configs.TILE_SIZE - Configs.CROP
            tile.x
            tile.y
            Configs.TILE_SIZE
            Configs.TILE_SIZE - Configs.CROP
          )
        )
        img.parentNode.removeChild(img)
        
        counter--
        cb(can) if not counter
      )
      
      document.body.appendChild(img)
      img.src = URL(tile.geo.lat, tile.geo.lng, style)

  
  document.body.appendChild(can.el)
  
module.exports = (tiles) ->
  loader(tiles, 'TERRAIN', (can)->
    can.ctx.save()
    greenScreen(can)
    pat = can.ctx.createPattern(resourceMap.EARTH.el, "repeat")
    can.ctx.globalCompositeOperation = "source-in"
    can.ctx.fillStyle = pat
    can.ctx.fillRect(0,0,can.width,can.height)
    can.ctx.restore()
    can.el.style.display = "block"
  )