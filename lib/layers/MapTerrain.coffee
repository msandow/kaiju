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
      
      createHex = (idx)=>
        pos = @cellIndexToxyPos(idx, @data)
        d = Utils.parseToTerrain( gameConfigs.terrain[idx] or 100000)
        @ctx.drawImage(d, pos.x, pos.y) if d
      
      i = 0
      while i < (gameConfigs.map_width * gameConfigs.map_height)
        createHex(i)
        i++
      
#      Utils.doForHexInViewPort(@data.viewPort, (idx)=>
#        createHex(idx, @data)
#      )

      @data.doRender = false
    )
  )