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


    gameLayers = [
      require('./layers/MapTerrain.coffee')(gameWindow)
      require('./layers/MapHexOverlay.coffee')(gameWindow)
    ]


    for layer in gameLayers
      gameWindow.appendChild(layer.el)


    gameEngine = ->
      for layer in gameLayers
        layer.build()


    gameInterval = setInterval(gameEngine, (1000 / gameConfigs.clock_ps))


    mouseMoveDebounced = Utils.debounce((evt)->
      gameLayers[1].data.mouseX = evt.clientX + gameWindow.scrollLeft - gameWindow.offsetLeft
      gameLayers[1].data.mouseY = evt.clientY + gameWindow.scrollTop - gameWindow.offsetTop
      gameLayers[1].data.doRender = true
    , 10)


    scrollDebounced = Utils.debounce((evt)->
      gameLayers[0].data.doRender = true
      gameLayers[1].data.doRender = true
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


    TabFocus(
      focus: ->
        gameInterval = setInterval(gameEngine, (1000 / gameConfigs.clock_ps))
      blur: ->
        clearInterval(gameInterval)
    )
  )