Util = require('./Utilities.coffee')

module.exports = (gameWindow)->
  
  window.gameWindow = gameWindow
  
  window.pixelRatio = do ->
    context = CanvasRenderingContext2D.prototype
    backingStore = context.backingStorePixelRatio or context.webkitBackingStorePixelRatio or context.mozBackingStorePixelRatio or context.msBackingStorePixelRatio or context.oBackingStorePixelRatio or context.backingStorePixelRatio or 1
    (window.devicePixelRatio or 1) / backingStore
  
  require('./HiDPI.coffee')()