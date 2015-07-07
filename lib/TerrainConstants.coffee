gameConfigs = require('./Configs.coffee')
StaticCanvas = require('./StaticCanvas.coffee')
Utils = require('./Utilities.coffee')

hexShape = () ->
  @ctx.beginPath()
  @ctx.moveTo(@data.hex_width * 0.25, 0)
  @ctx.lineTo(@data.hex_width * 0.75, 0)
  @ctx.lineTo(@data.hex_width, @data.hex_height * 0.5)
  @ctx.lineTo(@data.hex_width * 0.75, @data.hex_height)
  @ctx.lineTo(@data.hex_width * 0.25, @data.hex_height)
  @ctx.lineTo(0, @data.hex_height * 0.5)
  @ctx.closePath()


overlayWithAlterations = (base, overlay, specific, alt) ->
  return Hexes["#{base}#{overlay}#{specific}"] if Hexes["#{base}#{overlay}#{specific}"]
    
  Hexes["#{base}#{overlay}#{specific}"] = StaticCanvas(
    width: gameConfigs.hex_width
    height: gameConfigs.hex_height
    data: gameConfigs
    renderer: ->
      @ctx.drawImage(con.base[base].tile,0,0)
        
      newOverlay = StaticCanvas(
        width: gameConfigs.hex_width
        height: gameConfigs.hex_height
        data: gameConfigs
        renderer: ->
          @ctx.drawImage(con.base[overlay].tile,0,0)
          @ctx.globalCompositeOperation = 'destination-in'
          @ctx.beginPath()
          alt.call(@)
          @ctx.closePath()
          @ctx.fillStyle = '#000'
          @ctx.fill()
      )

      @ctx.drawImage(newOverlay,0,0)
  )

  return Hexes["#{base}#{overlay}#{specific}"]



parseToTerrain = (int) ->
  str = String(int)
  chunks = str.match(/\d{2,2}/g).map((c)-> parseInt(c))
  
  if chunks[1] and chunks[2]
    if not con.modifier[chunks[2]]
      console.error("No modifier found #{chunks[2]}")
      return false
    return con.modifier[chunks[2]](chunks[0], chunks[1])
  else
    if not con.base[chunks[0]]
      console.error("No hex found #{chunks[0]}")
      return false
    return con.base[chunks[0]].tile



#
# HEXES
#

Hexes = {}


Hexes.empty = StaticCanvas(
  width: gameConfigs.hex_width
  height: gameConfigs.hex_height
  data: gameConfigs
  renderer: ->
    hexShape.call(@)

    @ctx.strokeStyle = 'rgba(0,0,0,0.3)'
    @ctx.lineWidth = 1
    @ctx.stroke()
)


Hexes.grass = StaticCanvas(
  width: gameConfigs.hex_width
  height: gameConfigs.hex_height
  data: gameConfigs
  renderer: ->
    @ctx.drawImage(document.getElementById('hexes-low_grass.png'), 0, 0)
    @ctx.globalCompositeOperation = 'destination-in'
    hexShape.call(@)
    @ctx.fillStyle = '#000'
    @ctx.fill()
)


Hexes.water = StaticCanvas(
  width: gameConfigs.hex_width
  height: gameConfigs.hex_height
  data: gameConfigs
  renderer: ->
    @ctx.drawImage(document.getElementById('hexes-shallow_water.png'), 0, 0)
    @ctx.globalCompositeOperation = 'destination-in'
    hexShape.call(@)
    @ctx.fillStyle = '#000'
    @ctx.fill()
)



#
# CONSTANTS
#

con = {}
con.base =
  # Empty til
  10:
    tile: Hexes.empty

  # Grass tile
  11:
    tile: Hexes.grass

  # Water tile
  12:
    tile: Hexes.water
  
con.modifier =
  # Left to bottom left
  10: (base, overlay) ->
    overlayWithAlterations(base, overlay, 10, ()->
      @ctx.moveTo(0, @data.hex_height / 2)      

      @ctx.quadraticCurveTo(
        @data.hex_width / 2.2
        @data.hex_height / 2.2
        @data.hex_width * 0.25
        @data.hex_height
      )

      @ctx.lineTo(0, @data.hex_height)
    )


  # Left to bottom right
  11: (base, overlay) ->
    overlayWithAlterations(base, overlay, 11, ()->
      @ctx.moveTo(0, @data.hex_height / 2)      

      @ctx.quadraticCurveTo(
        @data.hex_width / 2.2
        @data.hex_height / 2.2
        @data.hex_width * 0.75
        @data.hex_height
      )

      @ctx.lineTo(0, @data.hex_height)
    )


  # Left to right
  12: (base, overlay) ->
    overlayWithAlterations(base, overlay, 12, ()->
      @ctx.rect(0, @data.hex_height / 2, @data.hex_width, @data.hex_height / 2)
    )


  # Left to top right
  13: (base, overlay) ->
    overlayWithAlterations(base, overlay, 13, ()->
      @ctx.moveTo(0, @data.hex_height / 2)      

      @ctx.quadraticCurveTo(
        @data.hex_width / 2.2
        @data.hex_height / 2.2
        @data.hex_width * 0.75
        0
      )
      
      @ctx.lineTo(@data.hex_width, 0)
      @ctx.lineTo(@data.hex_width, @data.hex_height)
      @ctx.lineTo(0, @data.hex_height)
    )


  # Left to top left
  14: (base, overlay) ->
    overlayWithAlterations(base, overlay, 14, ()->
      @ctx.moveTo(0, @data.hex_height / 2)      

      @ctx.quadraticCurveTo(
        @data.hex_width / 2.2
        @data.hex_height / 2.2
        @data.hex_width * 0.25
        0
      )
      
      @ctx.lineTo(@data.hex_width, 0)
      @ctx.lineTo(@data.hex_width, @data.hex_height)
      @ctx.lineTo(0, @data.hex_height)
    )

module.exports = 
  parseToTerrain: parseToTerrain