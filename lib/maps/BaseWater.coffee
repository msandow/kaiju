module.exports = (w, h)->
  width:w
  height:h
  left:50
  top:50
  opacity:0
  data:
    commands:[
      {command:"fill",data:[0,0,w,h,'#22506a']}
    ]