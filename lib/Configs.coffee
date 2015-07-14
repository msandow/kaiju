module.exports =
  TILE_SIZE: 640
  ZOOM: 13
  PIXEL_RATIO: do ->
    context = CanvasRenderingContext2D.prototype
    backingStore = context.backingStorePixelRatio or context.webkitBackingStorePixelRatio or context.mozBackingStorePixelRatio or context.msBackingStorePixelRatio or context.oBackingStorePixelRatio or context.backingStorePixelRatio or 1
    (window.devicePixelRatio or 1) / backingStore