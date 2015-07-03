gameConfigs = require('./../Configs.coffee')
Canvas = require('./../HexedCanvas.coffee')
Utils = require('./../Utilities.coffee')

module.exports = (gameWindow)->

  new Canvas(
    width: gameConfigs.x_bounds,
    height: gameConfigs.y_bounds,
    data: do ->
      confs = JSON.parse(JSON.stringify(gameConfigs))
      confs.doRender = true
      confs.viewPort = Utils.getViewPortInfo(gameWindow)
      
      confs
    ,
    calculator: (->
    
    )
    renderer: (->
      viewPort = @data.viewPort
      @ctx.fillStyle = 'rgba(0,0,0,0.35)'
      @ctx.fillRect(0,0,@width,@height)
      
      @data.doRender = false
    )
  )