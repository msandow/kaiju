gameConfigs = require('./../Configs.coffee')
Canvas = require('./../HexedCanvas.coffee')
Utils = require('./../Utilities.coffee')

module.exports = (gameWindow)->

  new Canvas(
    width: gameConfigs.x_bounds,
    height: gameConfigs.y_bounds,
    data: do ->
      confs = JSON.parse(JSON.stringify(gameConfigs))
      confs.activeCell = null
      confs.doRender = true
      
      confs
    ,
    calculator: (->
      
    )
    renderer: (->
      createHex = (idx, conf)=>
        pos = Utils.cellIndexToxyPos(idx, @data)
        d = Utils.parseToTerrain(100000)
        @ctx.drawImage(d, pos.x, pos.y) if d

      if typeof @data.activeCell is 'number' and @data.activeCell > -1
        createHex(@data.activeCell, @data)
      
#      Utils.doForHexInViewPort(@data.viewPort, (idx)=>
#        createHex(idx, @data)
#      )

      @data.doRender = false
    )
  )