Canvas = require('./CanvasBase.coffee')

module.exports = class extends Canvas
  doForHexInViewPort: (cb) ->
    viewPort = @data.viewPort or []
    crop_y = Math.max( Math.floor(viewPort[1] / gameConfigs.hex_height) - 1, 0)
    span_y = Math.min( Math.ceil(viewPort[3] / gameConfigs.hex_height) + 1, gameConfigs.map_height)
    crop_x = Math.max( Math.floor(viewPort[0] / (gameConfigs.hex_width * 0.75)) - 1, 0)
    span_x = Math.min( Math.ceil(viewPort[2] / (gameConfigs.hex_width * 0.75)) + 1, gameConfigs.map_width)

    i = (crop_y * gameConfigs.map_width) + crop_x
    rowCount = 0
    while i < ((span_y * gameConfigs.map_width) + span_x)
      cb(i)

      rowCount++
      if rowCount > span_x-crop_x
        rowCount = 0
        i += gameConfigs.map_width-(span_x-crop_x)
      else
        i++