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
      confs.center = 521
      
      confs
    ,
    calculator: (->
    
    )
    renderer: (->
      d = Utils.parseToTerrain(110000)
    
      createHex = (idx)=>
        pos = @cellIndexToxyPos(idx, @data)
        @ctx.drawImage(d, pos.x, pos.y) if d

      @ctx.save()
      @ctx.fillStyle = 'rgba(0,0,0,0.35)'
      @ctx.fillRect(0,0,@width,@height)
      @ctx.globalCompositeOperation = 'destination-in'
      @ctx.drawImage(gameLayers.hash.terrain.el, 0, 0)
      @ctx.globalCompositeOperation = 'destination-out'
      
      for idx in @hexAndRadius(@data.center,6)
        createHex(idx)
      
      @ctx.restore()
      @data.doRender = false
    )
  )