Configs = require('./Configs.coffee')
Canvas = require('./Canvas.coffee')
Geo = require('./Geo.coffee')
Loader = require('./TileLoader.coffee')
require('./HiDPI.coffee')(Configs.PIXEL_RATIO)


module.exports = ->
  tiles =
    lat: 37.787064
    lng: -122.340403
    width: 3
    height: 4
    cells: null
  
  tiles.cells = Geo(
    tiles.lat
    tiles.lng
    tiles.width
    tiles.height
  )

  Loader(tiles)
