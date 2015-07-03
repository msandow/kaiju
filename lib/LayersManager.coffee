module.exports = (gameWindow)->
  
  gameLayers = [
    require('./layers/MapTerrain.coffee')(gameWindow)
    require('./layers/MapFog.coffee')(gameWindow)
    require('./layers/MapHexOverlay.coffee')(gameWindow)
    require('./layers/MapHexActive.coffee')(gameWindow)
  ]

  for layer in gameLayers
    gameWindow.appendChild(layer.el)
    
  
  {
    arr: gameLayers
    hash:
      terrain: gameLayers[0]
      fog: gameLayers[1]
      hexes: gameLayers[2]
      activeHex: gameLayers[3]
  }