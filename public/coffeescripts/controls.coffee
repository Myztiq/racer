currentStatus =
  forward:
    down: false
    pressed: false
  backward:
    down: false
    pressed: false
  reset:
    down: false
    pressed: false
  rightTilt:
    down: false
    pressed: false
  leftTilt:
    down: false
    pressed: false

mapping =
  37: 'forward'
  39: 'backward'
  82: 'reset'
  90: 'leftTilt'
  88: 'rightTilt'

class Controls
  constructor: ->

    $('body').keydown (e)=>
      map = mapping[e.keyCode]
      if map?
        currentStatus[map].down = true

    $('body').keyup (e)=>
      map = mapping[e.keyCode]
      if map?
        currentStatus[map].down = false
        currentStatus[map].pressed = true


  getControlStatus: =>
    tmp = {}
    for key, obj of currentStatus
      tmp[key] =
        down: obj.down
        pressed: obj.pressed
      obj.pressed = false
    tmp


window.Controls = Controls