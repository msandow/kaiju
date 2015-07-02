module.exports = do ->
  ob = {}
  ob.hex_width = 40
  ob.hex_height = Math.round(ob.hex_width / 1.2)
  ob.map_width = 90
  ob.map_height = 90

  ob.x_bounds = (ob.hex_width * 1.5) * (ob.map_width / 2) + (ob.hex_width * 0.25)
  ob.y_bounds = (ob.map_height * ob.hex_height) + (ob.hex_height / 2)
  
  ob.clock_ps = 20
  ob.debug = true
  ob.version = 1
  
  ob