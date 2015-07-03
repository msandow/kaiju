gameConfigs = require('./Configs.coffee')

Utils = {}


Utils.triArea = (p0x, p0y, p1x, p1y, p2x, p2y)->
  1/2*(-p1y*p2x + p0y*(-p1x + p2x) + p0x*(p1y - p2y) + p1x*p2y)



Utils.pointInTri = (p0x, p0y, p1x, p1y, p2x, p2y, px, py)->
  area = Utils.triArea(p0x, p0y, p1x, p1y, p2x, p2y)
  s = 1/(2*area)*(p0y*p2x - p0x*p2y + (p2y - p0y)*px + (p0x - p2x)*py)
  t = 1/(2*area)*(p0x*p1y - p0y*p1x + (p0y - p1y)*px + (p1x - p0x)*py)

  0 <= s <= 1 && 0 <= t <= 1 && 0 <= (1-s-t) <= 1



Utils.getPixelRatio = (context) ->
  if (gameConfigs.map_width * gameConfigs.map_height) >= gameConfigs.areaLimit
    return 1
  
  backingStore = context.backingStorePixelRatio or context.webkitBackingStorePixelRatio or context.mozBackingStorePixelRatio or context.msBackingStorePixelRatio or context.oBackingStorePixelRatio or context.backingStorePixelRatio or 1
  (window.devicePixelRatio or 1) / backingStore



Utils.cellIndexToxyPos = (idx, conf)->
  yy = (Math.floor(idx/conf.map_width))
  xx = (idx - (yy*conf.map_width))

  pos_xx = xx*(conf.hex_width) - (xx * (conf.hex_width * 0.25))
  pos_yy = (yy*conf.hex_height )
  offset = !!(idx%2)

  if offset
    pos_yy += (conf.hex_height * 0.5)
  
  #pos_xx -= Math.round(conf.hex_width /2)
  #pos_yy -= Math.round(conf.hex_height /2)
  
  return {x: pos_xx, y: pos_yy}



Utils.xyPosToCellIndex = (x, y, conf)->
  lastHex = -1

  if 0 < x < conf.x_bounds && 0 < y < conf.y_bounds
    xx = Math.floor(x / (conf.hex_width*0.75))
    yy = (Math.floor(y / conf.hex_height))
    square_start = [xx * (conf.hex_width*0.75), yy * conf.hex_height]

    if !(xx%2)
      if Utils.pointInTri(square_start[0], square_start[1], square_start[0] + (conf.hex_width * 0.25), square_start[1], square_start[0], square_start[1] + (conf.hex_height * 0.5), x, y)
        lastHex = (((yy * conf.map_width) + xx) - 1) - conf.map_width
      else if Utils.pointInTri(square_start[0], square_start[1] + (conf.hex_height * 0.5), square_start[0] + (conf.hex_width * 0.25), square_start[1] + conf.hex_height, square_start[0], square_start[1] + conf.hex_height, x, y)
        lastHex = ((yy * conf.map_width) + xx) - 1
      else
        lastHex = (yy * conf.map_width) + xx
    else
      if Utils.pointInTri(square_start[0], square_start[1], square_start[0] + (conf.hex_width * 0.25), square_start[1] + (conf.hex_height * 0.5), square_start[0], square_start[1] + conf.hex_height, x, y)
        lastHex = (yy * conf.map_width) + (xx - 1)
      else if y <= square_start[1] + (conf.hex_height * 0.5)
        lastHex = (((yy) * conf.map_width) + xx) - conf.map_width
      else
        lastHex = (((yy) * conf.map_width) + xx)
    
    if lastHex > -1
      renderSpace = Utils.cellIndexToxyPos(lastHex, conf)
      
      if (!(renderSpace.x <= x <= renderSpace.x + conf.hex_width) || !(renderSpace.y <= y <= renderSpace.y + conf.hex_height))
        lastHex = -1
    
  lastHex



Utils.debounce = (func, wait) ->
  # we need to save these in the closure
  timeout = undefined
  args = undefined
  context = undefined
  timestamp = undefined
  ->
    context = this
    args = [].slice.call(arguments, 0)
    timestamp = new Date

    later = ->
      last = new Date - timestamp
      if last < wait
        timeout = setTimeout(later, wait - last)
      else
        timeout = null
        func.apply context, args
      return

    if !timeout
      timeout = setTimeout(later, wait)
    return


Utils.getViewPortInfo = (gameWindow) ->
  [
    gameWindow.scrollLeft,
    gameWindow.scrollTop,
    gameWindow.scrollLeft + window.innerWidth,
    gameWindow.scrollTop + window.innerHeight
  ]



Utils.stringToID = (str='') ->
  str.replace(/[^a-zA-Z0-9\-_:\.]/gi, '-')


Utils.parseToTerrain = (int) ->
  require('./TerrainConstants.coffee').parseToTerrain(int)


Utils.generateHexes = (int) ->
  require('./TerrainConstants.coffee').generateHexes()


Utils.random = (from, to) ->
  ~~Math.floor(Math.random() * to) + from

module.exports = Utils