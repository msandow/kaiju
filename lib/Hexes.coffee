StaticCanvas = require('./StaticCanvas.coffee')
gameConfigs = require('./Configs.coffee')

hexShape = () ->
  @ctx.beginPath()
  @ctx.moveTo(@data.hex_width * 0.25, 0)
  @ctx.lineTo(@data.hex_width * 0.75, 0)
  @ctx.lineTo(@data.hex_width, @data.hex_height * 0.5)
  @ctx.lineTo(@data.hex_width * 0.75, @data.hex_height)
  @ctx.lineTo(@data.hex_width * 0.25, @data.hex_height)
  @ctx.lineTo(0, @data.hex_height * 0.5)
  @ctx.closePath()


Hexes = {}


Hexes.empty = StaticCanvas(
  width: gameConfigs.hex_width,
  height: gameConfigs.hex_height,
  data: gameConfigs,
  renderer: (->
    hexShape.call(@)

    @ctx.strokeStyle = 'rgba(0,0,0,0.2)'
    @ctx.lineWidth = 1
    @ctx.stroke()
  )
)


Hexes.grass = StaticCanvas(
  width: gameConfigs.hex_width,
  height: gameConfigs.hex_height,
  data: gameConfigs,
  renderer: (->
    @ctx.fillStyle = '#ddf687'
    @ctx.fillRect(0,0,@data.hex_width,@data.hex_height)
    @ctx.globalCompositeOperation = 'destination-in'
    hexShape.call(@)
    @ctx.fillStyle = '#000'
    @ctx.fill()
  )
)


module.exports = Hexes