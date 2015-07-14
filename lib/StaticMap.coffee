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
        { "color": "#00FF00" },
        { "visibility": "simplified" }
      ]
    }
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [
        { "color": "#FF00FF" },
        { "visibility": "simplified" }
      ]
    }
  ]

  MANMADE: [
    {
      "stylers": [
        { "visibility": "off" }
      ]
    }
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        { "color": "#00FF00" },
        { "visibility": "simplified" }
      ]
    }
    {
      "featureType": "landscape.natural",
      "elementType": "geometry",
      "stylers": [
        { "color": "#00FF00" },
        { "visibility": "on" }
      ]
    }
    {
      "featureType": "landscape.man_made",
      "elementType": "geometry",
      "stylers": [
        { "color": "#FF00FF" },
        { "visibility": "on" }
      ]
    }
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
  
  qs = qs.substring(1) if qs.length
  
  qs

module.exports = (lat, lng, style="")->
  
  if style and STYLES[style]
    style = STYLES[style]
  else
    style = {}
  
  str = """
  https://maps.googleapis.com/maps/api/staticmap?
  key=AIzaSyA8WwJ-pQ4_jkOVZw5OmYWT4wv9qQC0n48&
  center=#{lat},#{lng}&
  zoom=#{Configs.ZOOM}&
  scale=#{Configs.PIXEL_RATIO}&
  format=PNG&
  size=#{Configs.TILE_SIZE}x#{Configs.TILE_SIZE}&maptype=roadmap&
  #{styleToQS(style)}
  """
  
  str.replace(/\r|\n|\r\n/gim,'')