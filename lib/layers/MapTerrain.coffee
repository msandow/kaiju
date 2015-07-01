gameConfigs = require('./../Configs.coffee')
Canvas = require('./../CanvasBase.coffee')
Hexes = require('./../Hexes.coffee')
Utils = require('./../Utilities.coffee')

module.exports = (gameWindow)->

  new Canvas(
    width: gameConfigs.x_bounds,
    height: gameConfigs.y_bounds,
    data: gameConfigs,
    calculator: (->
      @data.viewPort = Utils.getViewPortInfo(gameWindow)
    )
    renderer: (->
      viewPort = @data.viewPort
      
      createHex = (idx, conf)=>
        pos = Utils.cellIndexToxyPost(idx, @data)        

        @ctx.globalAlpha = if idx is conf.activeCell then 0.5 else 0.1
        @ctx.drawImage(Hexes.grass, pos.x, pos.y)
      
      Utils.doForHexInViewPort(@data.viewPort, (idx)=>
        createHex(idx, @data)
      )

      @data.doRender = false
    )
  )