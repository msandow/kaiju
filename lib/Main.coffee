Configs = require('./Configs.coffee')
Canvas = require('./Canvas.coffee')
Geo = require('./Geo.coffee')
URL = require('./StaticMap.coffee')

module.exports = ->
  cells = Geo(37.787064,-122.340403,4,3)

  #console.log(URL(37.787064,-122.340403,'TERRAIN'))
  console.log(cells)
  for i in cells
    img = document.createElement('img')
    img.src = URL(i.geo.lat, i.geo.lng,'TERRAIN')
    img.width = Configs.TILE_SIZE
    img.height = Configs.TILE_SIZE
    img.style.left = "#{i.x}px"
    img.style.top = "#{i.y}px"
    document.body.appendChild(img)