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
      confs.mouseX = 0
      confs.mouseY = 0
      confs.doRender = true
      confs.viewPort = []
      
      confs
    ,
    calculator: (->     
      @data.activeCell = Utils.xyPosToCellIndex(@data.mouseX, @data.mouseY, @data)
      @data.viewPort = Utils.getViewPortInfo(gameWindow)
    )
    renderer: (->
      viewPort = @data.viewPort
      
      createHex = (idx, conf)=>
        pos = Utils.cellIndexToxyPost(idx, @data)        

        @ctx.globalAlpha = if idx is conf.activeCell then 1 else 0.1
        @ctx.drawImage(Hexes.empty, pos.x, pos.y)
      
      Utils.doForHexInViewPort(@data.viewPort, (idx)=>
        createHex(idx, @data)
      )

      @data.doRender = false
    )
  )