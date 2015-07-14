Configs = require('./Configs.coffee')
Canvas = require('./Canvas.coffee')
URL = require('./StaticMap.coffee')

module.exports = (tiles) ->
  can = new Canvas(
    width: tiles.width * Configs.TILE_SIZE
    height: tiles.height * (Configs.TILE_SIZE - Configs.CROP)
  )
  
  for tile in tiles.cells
    do (tile)->
      img = document.createElement('img')
      
      img.width = Configs.TILE_SIZE
      img.height = Configs.TILE_SIZE

      img.style.display = "none"
      img.crossOrigin = ""
      
      img.addEventListener('load', ()->
        can.exec(->
          console.log(tile.x)
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
      )
      
      document.body.appendChild(img)
      img.src = URL(tile.geo.lat, tile.geo.lng,'TERRAIN')

  
  document.body.appendChild(can.el)