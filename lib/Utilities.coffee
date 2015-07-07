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
      cx + sx * (ps[0] - cx)
      cy + sy * (ps[1] - cy)
    ]
  )



U.rand = (n, x)->
  Math.floor(Math.random()*(x-n+1)+n)



U.midPoint = (a, b)->
  [(a[0]+b[0])/2, (a[1]+b[1])/2]



U.noisify = (points)->
  newArr = []
  i = 0
  
  rando = (i)->
    U.rand(i-4, i+4)
  
  while i < points.length
    newArr.push(points[i])
    if points[i+1]
      mid = U.midPoint(points[i], points[i+1]).map(rando)
    else
      mid = U.midPoint(points[i], points[0]).map(rando)

    newArr.push(mid)
    i++

  newArr



U.translate = (points, x, y)->
  points.map((i)->
    [i[0]+x,i[1]+y]
  )


U.bounds = (points)->
  xs = []
  ys = []
  i = 0
  while i < points.length
    xs.push(points[i][0])
    ys.push(points[i][1])
    i++
  
  [
    Math.min.apply(null, xs)
    Math.min.apply(null, ys)
    Math.max.apply(null, xs)
    Math.max.apply(null, ys)
  ]


module.exports = U