module.exports = do ->
  ob = {}
  ob.hex_width = 40
  ob.hex_height = Math.round(ob.hex_width / 1.2)
  ob.map_width = 150
  ob.map_height = 150

  ob.x_bounds = (ob.hex_width * 1.5) * (ob.map_width / 2) + (ob.hex_width * 0.25)
  ob.y_bounds = (ob.map_height * ob.hex_height) + (ob.hex_height / 2)
  
  ob.areaLimit = 120 * 121
  ob.clock_ps = 20
  ob.debug = true
  ob.version = 1
  
  ob.terrain = Array(ob.map_width * ob.map_height)
  i = 0
  while i < ob.terrain.length
    ob.terrain[i] = 110000
    i++
    
  
  ob.terrain[521] = 120000
  
  ob