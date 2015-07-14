Configs = require('./Configs.coffee')

STYLES =
  TERRAIN: [
    {
      "stylers": [
        { "visibility": "off" }
      ]
    }
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        { "color": "#80ff80" },
        { "visibility": "simplified" }
      ]
    }
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [
        { "color": "#828080" },
        { "visibility": "simplified" }
      ]
    }
#    {
#      "featureType": "landscape.natural",
#      "elementType": "geometry",
#      "stylers": [
#        { "visibility": "on" },
#        { "color": "#6e806f" }
#      ]
#    }
  ]


styleToQS = (ob)->
  qs = ''
  
  for item in ob
    qs += "&style="
    
    if item.featureType
      qs += "feature:#{item.featureType}"
    
    if item.featureType and item.elementType
      qs += "|"
    
    if item.elementType
      qs += "element:#{item.elementType}"
    
    if item.stylers
      qs += "|"
    
    for st in item.stylers
      for own k,v of st
        if v[0] is "#"
          qs += "#{k}:0x#{v.substring(1)}"
        else
          qs += "#{k}:#{v}"
        
        qs += "|"
  
  qs

module.exports = (lat, lng, style="")->
  
  if style and STYLES[style]
    style = STYLES[style]
  else
    style = {}
  
  str = """
  https://maps.googleapis.com/maps/api/staticmap?
  center=#{lat},#{lng}&
  zoom=#{Configs.ZOOM}&
  scale=#{Configs.PIXEL_RATIO}&
  format=PNG&
  size=#{Configs.TILE_SIZE}x#{Configs.TILE_SIZE}&maptype=roadmap&
  #{styleToQS(style)}
  """
  
  str.replace(/\r|\n|\r\n/gim,'')