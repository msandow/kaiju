Configs = require('./Configs.coffee')

Point = class
  constructor: (@x, @y) ->


LatLng = class
  constructor: (@lat, @lng) ->


mercator =
  MERCATOR_RANGE: 256
  bound: (value, opt_min, opt_max) ->
    if opt_min != null
      value = Math.max(value, opt_min)
    if opt_max != null
      value = Math.min(value, opt_max)
    value
  degreesToRadians: (deg) ->
    deg * Math.PI / 180
  radiansToDegrees: (rad) ->
    rad / (Math.PI / 180)
  MercatorProjection: ->
    @pixelOrigin_ = new Point(mercator.MERCATOR_RANGE / 2, mercator.MERCATOR_RANGE / 2)
    @pixelsPerLonDegree_ = mercator.MERCATOR_RANGE / 360
    @pixelsPerLonRadian_ = mercator.MERCATOR_RANGE / (2 * Math.PI)

    @fromLatLngToPoint = (latLng, opt_point) ->
      me = this
      point = opt_point or new Point(0, 0)
      origin = me.pixelOrigin_
      point.x = origin.x + latLng.lng * me.pixelsPerLonDegree_
      siny = mercator.bound(Math.sin(mercator.degreesToRadians(latLng.lat)), -0.9999, 0.9999)
      point.y = origin.y + 0.5 * Math.log((1 + siny) / (1 - siny)) * -me.pixelsPerLonRadian_
      point

    @fromPointToLatLng = (point) ->
      me = this
      origin = me.pixelOrigin_
      lng = (point.x - (origin.x)) / me.pixelsPerLonDegree_
      latRadians = (point.y - (origin.y)) / -me.pixelsPerLonRadian_
      lat = mercator.radiansToDegrees(2 * Math.atan(Math.exp(latRadians)) - (Math.PI / 2))
      new LatLng(lat, lng)

    return
  getCorners: (center, zoom, mapWidth, mapHeight) ->
    proj = new (mercator.MercatorProjection)
    scale = 2 ** zoom
    centerPx = proj.fromLatLngToPoint(center)
    SWPoint = 
      x: centerPx.x - (mapWidth / 2 / scale)
      y: centerPx.y + mapHeight / 2 / scale
    NEPoint = 
      x: centerPx.x + mapWidth / 2 / scale
      y: centerPx.y - (mapHeight / 2 / scale)
    {
      ne: proj.fromPointToLatLng(NEPoint)
      sw: proj.fromPointToLatLng(SWPoint)
    }
  getDisplaySize: (corners) ->
    {
      h: corners.sw.lat - (corners.ne.lat)
      w: corners.ne.lng - (corners.sw.lng)
    }

getMapUrl = (lat, long, zoom, mapType) ->
  (mapVars.base + mapType).replace('{{latLong}}', lat + ',' + long).replace('{{zoom}}', zoom).replace '{{type}}', if mapType == '&style=visibility:off' then 'terrain' else 'roadmap'


_ar = (24 / 36)
_cell_ar = (Configs.TILE_SIZE - 25)

module.exports = (lat, lng, widthCells, heightCells) ->
  _zoom = Configs.ZOOM
  _complete = 0
  _size = mercator.getDisplaySize(mercator.getCorners(new LatLng(lat, lng), _zoom, Configs.TILE_SIZE, Configs.TILE_SIZE))
  _degH = _size.h / Configs.TILE_SIZE
  _degW = _size.w / Configs.TILE_SIZE
  _vertCells = ~~(heightCells/2)
  _vertUnits = 0
  _horCells = ~~(widthCells/2)
  _horUnits = 0
  
  cells = []
  
  if widthCells%2 is 0
    _horUnits += 0.5
    
  if heightCells%2 is 0
    _vertUnits += 0.5
  
  ww = -_horCells + _horUnits
  ww_translate = ww * Configs.TILE_SIZE
  hh = -_vertCells + _vertUnits
  hh_translate = hh * Configs.TILE_SIZE
  
  while hh <= _vertCells
    
    while ww <= _horCells
      cells.push({
        x: (ww * Configs.TILE_SIZE) - ww_translate
        y: (hh * Configs.TILE_SIZE) - hh_translate
        geo: new LatLng(lat + (_size.h * hh), lng + ( _size.w * ww))
      })
      ww++
    
    ww = -_horCells + _horUnits
    hh++
  
#  return [
#    new LatLng(lat-(_degH*1), lng-(_size.w*1.5))
#    new LatLng(lat-(_degH*1),lng-(_size.w*0.5))
#  ]

  cells
#_async.series [
#    (cb) ->
#      _imgToCanvas lat - (_size.h), lng - (_size.w * 1.5), cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_size.h), lng - (_size.w * 0.5), cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_size.h), lng + _size.w * 0.5, cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_size.h), lng + _size.w * 1.5, cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_degH * 25), lng - (_size.w * 1.5), cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_degH * 25), lng - (_size.w * 0.5), cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_degH * 25), lng + _size.w * 0.5, cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_degH * 25), lng + _size.w * 1.5, cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_degH * 50) + _size.h, lng - (_size.w * 1.5), cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_degH * 50) + _size.h, lng - (_size.w * 0.5), cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_degH * 50) + _size.h, lng + _size.w * 0.5, cb
#      return
#    (cb) ->
#      _imgToCanvas lat - (_degH * 50) + _size.h, lng + _size.w * 1.5, cb
#      return
#  ], (result) ->
#    cb result
#    return
#  return