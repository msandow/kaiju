gameConfigs = require('./../Configs.coffee')
Canvas = require('./../CanvasBase.coffee')
Hexes = require('./../Hexes.coffee')
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
        pos = Utils.cellIndexToxyPost(idx, @data)
        @ctx.drawImage(Hexes.empty, pos.x, pos.y)

      if @data.activeCell and @data.activeCell > -1
        createHex(@data.activeCell, @data)
      
#      Utils.doForHexInViewPort(@data.viewPort, (idx)=>
#        createHex(idx, @data)
#      )

      @data.doRender = false
    )
  )