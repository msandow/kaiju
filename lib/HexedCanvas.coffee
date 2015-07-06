Canvas = require('./CanvasBase.coffee')
gameConfigs = require('./Configs.coffee')
Utils = require('./Utilities.coffee')

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


  cellIndexToxyPos: (idx)->
    conf = @data
    yy = (Math.floor(idx/conf.map_width))
    xx = (idx - (yy*conf.map_width))

    pos_xx = xx*(conf.hex_width) - (xx * (conf.hex_width * 0.25))
    pos_yy = (yy*conf.hex_height )
    offset = !!(idx%2)

    if offset
      pos_yy += (conf.hex_height * 0.5)

    #pos_xx -= Math.round(conf.hex_width /2)
    #pos_yy -= Math.round(conf.hex_height /2)

    {x: pos_xx, y: pos_yy}




  xyPosToCellIndex: (x, y)->
    conf = @data
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
        renderSpace = @cellIndexToxyPos(lastHex, conf)

        if (!(renderSpace.x <= x <= renderSpace.x + conf.hex_width) || !(renderSpace.y <= y <= renderSpace.y + conf.hex_height))
          lastHex = -1

    lastHex




  hexAndRadius: (idx, radius)->
    up = idx - (gameConfigs.map_width * radius)
    down = idx + (gameConfigs.map_width * radius)
    center = @cellIndexToxyPos(idx)

    cells = []
    row = 0
    
    ys = 0-radius
    xs = 0-radius
    
    i = up - radius
    while i <= down + radius
      p = @cellIndexToxyPos(i)
      #p.x += xs * (gameConfigs.hex_width-gameConfigs.hex_height)
      if Utils.pointInCircle(center.x, center.y, p.x, p.y, (radius * gameConfigs.hex_width))
        cells.push(i)
      
      if row < radius * 2
        row++
        i++
        xs++
      else
        row = 0
        i += gameConfigs.map_width-(radius*2)
        ys++
        xs = 0-radius
    #console.log(expected,cells.length)
    cells