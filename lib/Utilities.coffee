U = {}



U.getViewPortInfo = () ->
  [
    window.gameWindow.scrollLeft,
    window.gameWindow.scrollTop,
    window.gameWindow.scrollLeft + window.innerWidth,
    window.gameWindow.scrollTop + window.innerHeight
  ]



U.scalePoints = (points, cx, cy, sx, sy)->
  sy = sx if typeof sy is 'undefined'
  points.map((ps)->
    [
      Math.round(cx + sx * (ps[0] - cx))
      Math.round(cy + sy * (ps[1] - cy))
    ]
  )



U.rand = (n, x)->
  Math.floor(Math.random()*(x-n+1)+n)



U.midPoint = (a, b)->
  [(a[0]+b[0])/2, (a[1]+b[1])/2]



U.noisify = (points, spread=4)->
  newArr = []
  i = 0
  
  rando = (i)->
    U.rand(i-spread, i+spread)
  
  while i < points.length - 1
    newArr.push(points[i])
    if points[i+1]
      mid = U.midPoint(points[i], points[i+1]).map(rando)
    else
      mid = U.midPoint(points[i], points[0]).map(rando)

    newArr.push(mid)
    i++
  
  newArr.push(points[points.length-1])

  newArr



U.translate = (points, x, y)->
  points.map((i)->
    return i if !Array.isArray(i)
    [i[0]+x,i[1]+y]
  )


U.bounds = (points)->
  [mnx, mxx, mny, mxy] = [0, 0, 0, 0]

  for p in points
    mnx = p[0] if p[0] < mnx
    mxx = p[0] if p[0] > mxx
    mny = p[1] if p[1] < mny
    mxy = p[1] if p[1] > mxy

  [
    mnx
    mny
    mxx
    mxy
    mxx - mnx
    mxy - mny
  ]



U.center = (points)->
  b = U.bounds(points)
  [Math.round((b[2]-b[0])/2), Math.round((b[3]-b[1])/2)]



U.getEventCoords = (evt, el={offsetLeft:0, offsetTop:0})->
  [
    evt.clientX + window.gameWindow.scrollLeft - window.gameWindow.offsetLeft - el.offsetLeft,
    evt.clientY + window.gameWindow.scrollTop - window.gameWindow.offsetTop - el.offsetTop
  ]

module.exports = U