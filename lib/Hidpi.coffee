gameConfigs = require('./Configs.coffee')
Utils = require('./Utilities.coffee')

module.exports = ->
  ((prototype) ->
    pixelRatio = Utils.getPixelRatio(prototype)
    
    if (gameConfigs.map_width * gameConfigs.map_height) >= gameConfigs.areaLimit
      return
    
    ratioArgs = 
      'fillRect': 'all'
      'clearRect': 'all'
      'strokeRect': 'all'
      'moveTo': 'all'
      'lineTo': 'all'
      'arc': [
        0
        1
        2
      ]
      'arcTo': 'all'
      'bezierCurveTo': 'all'
      'isPointinPath': 'all'
      'isPointinStroke': 'all'
      'quadraticCurveTo': 'all'
      'rect': 'all'
      'translate': 'all'
      'createRadialGradient': 'all'
      'createLinearGradient': 'all'
    
    if pixelRatio == 1
      return
    
    for own key, value of ratioArgs
      prototype[key] = ((_super) ->
        ->
          i = undefined
          len = undefined
          args = Array::slice.call(arguments)
          if value == 'all'
            args = args.map((a) ->
              a * pixelRatio
            )
          else if Array.isArray(value)
            i = 0
            len = value.length
            while i < len
              args[value[i]] *= pixelRatio
              i++
          _super.apply this, args
      )(prototype[key])
    
    # Stroke lineWidth adjustment
    prototype.stroke = ((_super) ->
      ->
        @lineWidth *= pixelRatio
        _super.apply this, arguments
        @lineWidth /= pixelRatio
        return
    )(prototype.stroke)
    
    # Text
    #
    prototype.fillText = ((_super) ->
      ->
        args = Array::slice.call(arguments)
        args[1] *= pixelRatio
        # x
        args[2] *= pixelRatio
        # y
        @font = @font.replace(/(\d+)(px|em|rem|pt)/g, (w, m, u) ->
          m * pixelRatio + u
        )
        _super.apply this, args
        @font = @font.replace(/(\d+)(px|em|rem|pt)/g, (w, m, u) ->
          m / pixelRatio + u
        )
        return
    )(prototype.fillText)
    
    prototype.strokeText = ((_super) ->
      ->
        args = Array::slice.call(arguments)
        args[1] *= pixelRatio
        # x
        args[2] *= pixelRatio
        # y
        @font = @font.replace(/(\d+)(px|em|rem|pt)/g, (w, m, u) ->
          m * pixelRatio + u
        )
        _super.apply this, args
        @font = @font.replace(/(\d+)(px|em|rem|pt)/g, (w, m, u) ->
          m / pixelRatio + u
        )
        return
    )(prototype.strokeText)
    
    # Images
    #
    prototype.drawImage = ((_super) ->
      ->
        args = Array::slice.call(arguments)
        ctx = args[0]
        mappedArgs = []
        
        if args.length is 3
          mappedArgs = [
            args[0]
            0
            0
            ctx.width
            ctx.height
            args[1]
            args[2]
            ctx.width
            ctx.height
          ]
        else if args.length is 5
          mappedArgs = [
            args[0]
            ctx.width
            ctx.height
            ctx.width
            ctx.height
            args[1]
            args[2]
            args[3]
            args[4]
          ]
        else if args.length is 9
          mappedArgs = args
        
        for item, idx in mappedArgs when idx > 0
          mappedArgs[idx] = mappedArgs[idx] * pixelRatio
          true

        _super.apply this, mappedArgs
        return
    )(prototype.drawImage)

  )(CanvasRenderingContext2D.prototype)