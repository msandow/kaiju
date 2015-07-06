require('./Hidpi.coffee')()

Utils = require('./Utilities.coffee')
gameConfigs = require('./Configs.coffee')
TabFocus = require('./TabFocus.coffee')
Defer = require('./LoadResources.coffee')
Layers = require('./LayersManager.coffee')

module.exports = ->
  if gameConfigs.map_width % 2 or gameConfigs.map_height % 2
    console.error('Map width and height must be multiples of 2')
    return
  
  console.log("Loading resources") if gameConfigs.debug
  
  Defer([
    'images/hexes/low_grass.png'
    'images/hexes/shallow_water.png'
  ],->
    console.log("Resources loaded") if gameConfigs.debug
    
    gameWindow = document.querySelector('.window')
    
    TAB_ACTIVE = true

    gameLayers = Layers(gameWindow)


    gameEngine = ->
      if TAB_ACTIVE
        for layer in gameLayers.arr
          layer.build()
      
      setTimeout(->
        gameEngine()
      , (1000 / gameConfigs.clock_ps))


    mouseMoveDebounced = Utils.debounce((evt)->
      newActive = gameLayers.hash.activeHex.xyPosToCellIndex(
        evt.clientX + gameWindow.scrollLeft - gameWindow.offsetLeft,
        evt.clientY + gameWindow.scrollTop - gameWindow.offsetTop
      )

      if newActive isnt gameLayers.hash.activeHex.data.activeCell        
        gameLayers.hash.activeHex.data.activeCell = newActive
        gameLayers.hash.activeHex.data.doRender = true
    , 10)


    scrollDebounced = Utils.debounce((evt)->
      true
      #vp =  Utils.getViewPortInfo(gameWindow)
      #gameLayers[0].data.viewPort = vp
      #gameLayers[1].data.viewPort = vp
      #gameLayers[0].data.doRender = true
      #gameLayers[1].data.doRender = true
    , 10)


    gameWindow.addEventListener("mousemove", (evt)->
      mouseMoveDebounced(evt)
    )


    gameWindow.addEventListener("scroll", (evt)->
      scrollDebounced(evt)
    )


    window.addEventListener("resize", (evt)->
      scrollDebounced(evt)
    )


    if gameConfigs.debug
      gameWindow.addEventListener("click", (evt)->
        console.log(
          gameLayers.hash.activeHex.xyPosToCellIndex(
            evt.clientX + gameWindow.scrollLeft - gameWindow.offsetLeft,
            evt.clientY + gameWindow.scrollTop - gameWindow.offsetTop
          )
        )
      )


    gameEngine()

    TabFocus(
      focus: ->
        TAB_ACTIVE = true
      blur: ->
        TAB_ACTIVE = false
    )
  )