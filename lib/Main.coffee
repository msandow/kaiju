require('./Hidpi.coffee')()

Utils = require('./Utilities.coffee')
gameConfigs = require('./Configs.coffee')
TabFocus = require('./TabFocus.coffee')
Defer = require('./LoadResources.coffee')

module.exports = ->
  Defer([
    'https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg'
  ],->
    gameWindow = document.querySelector('.window')


    TAB_ACTIVE = true


    gameLayers = [
      require('./layers/MapTerrain.coffee')(gameWindow)
      require('./layers/MapHexOverlay.coffee')(gameWindow)
      require('./layers/MapHexActive.coffee')(gameWindow)
    ]


    for layer in gameLayers
      gameWindow.appendChild(layer.el)


    gameEngine = ->
      s = new Date().getTime() if gameConfigs.debug
      if TAB_ACTIVE
        for layer in gameLayers
          layer.build()
      s = new Date().getTime() - s if gameConfigs.debug
      console.log("Cycle took",s) if gameConfigs.debug and s
      
      setTimeout(->
        gameEngine()
      , (1000 / gameConfigs.clock_ps))


    mouseMoveDebounced = Utils.debounce((evt)->
      newActive = Utils.xyPosToCellIndex(
        evt.clientX + gameWindow.scrollLeft - gameWindow.offsetLeft,
        evt.clientY + gameWindow.scrollTop - gameWindow.offsetTop,
        gameLayers[2].data
      )
      if newActive isnt gameLayers[2].data.activeCell        
        gameLayers[2].data.activeCell = newActive
        gameLayers[2].data.doRender = true
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

    gameEngine()

    TabFocus(
      focus: ->
        TAB_ACTIVE = true
      blur: ->
        TAB_ACTIVE = false
    )
  )