module.exports = (w, h)->
  width:w
  height:h
  left:0
  top:0
  data:
    commands:[
      {command:"fill",data:[0,0,w,h,'#22506a']}
    ]