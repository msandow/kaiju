gameConfigs = require('./Configs.coffee')

Utils = {}


Utils.triArea = (p0x, p0y, p1x, p1y, p2x, p2y)->
  1/2*(-p1y*p2x + p0y*(-p1x + p2x) + p0x*(p1y - p2y) + p1x*p2y)



Utils.pointInTri = (p0x, p0y, p1x, p1y, p2x, p2y, px, py)->
  area = Utils.triArea(p0x, p0y, p1x, p1y, p2x, p2y)
  s = 1/(2*area)*(p0y*p2x - p0x*p2y + (p2y - p0y)*px + (p0x - p2x)*py)
  t = 1/(2*area)*(p0x*p1y - p0y*p1x + (p0y - p1y)*px + (p1x - p0x)*py)

  0 <= s <= 1 && 0 <= t <= 1 && 0 <= (1-s-t) <= 1



Utils.pointInCircle = (centerX, centerY, x, y, r)->
  Math.sqrt((x-centerX)*(x-centerX) + (y-centerY)*(y-centerY)) <= r



Utils.getPixelRatio = (context) ->
  if (gameConfigs.map_width * gameConfigs.map_height) >= gameConfigs.areaLimit
    return 1
  
  backingStore = context.backingStorePixelRatio or context.webkitBackingStorePixelRatio or context.mozBackingStorePixelRatio or context.msBackingStorePixelRatio or context.oBackingStorePixelRatio or context.backingStorePixelRatio or 1
  (window.devicePixelRatio or 1) / backingStore




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