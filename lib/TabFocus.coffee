getState = ->
  state = false
  
  if typeof document.hidden != 'undefined'
    state = 'visibilityState'
  else if typeof document.mozHidden != 'undefined'
    state = 'mozVisibilityState'
  else if typeof document.msHidden != 'undefined'
    state = 'msVisibilityState'
  else if typeof document.webkitHidden != 'undefined'
    state = 'webkitVisibilityState'
  else if typeof document.oHidden != 'undefined'
    state = 'oVisibilityState'
  
  state

getEvent = ->
  state

module.exports = (conf={}) ->
  focus = conf.focus or (->)
  blur = conf.blur or (->)
  
  state = getState()
  
  if state and document[getState()]
    evtName = state.replace('State', 'change').toLowerCase()
    
    document.addEventListener(evtName, ()->
      state = document[getState()]
      
      if state is 'hidden'
        blur()
      else
        focus()
    )