b2Vec2 = Box2D.Common.Math.b2Vec2
b2World = Box2D.Dynamics.b2World
b2DebugDraw = Box2D.Dynamics.b2DebugDraw

class Game

  constructor: ->
    @controls = new Controls()
    @world = new b2World(new b2Vec2(0, 10), true)
    new Track(@world)
    @car = new Car(@world)
    debugDraw = new b2DebugDraw()
    debugDraw.SetSprite document.getElementById("canvas").getContext("2d")
    debugDraw.SetDrawScale 30.0
    debugDraw.SetFillAlpha 0.5
    debugDraw.SetLineThickness 1.0
    debugDraw.SetFlags b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit
    @world.SetDebugDraw debugDraw
    window.setInterval @update, 1000 / 60

  update: =>
    controlStatus = @controls.getControlStatus()
    if controlStatus.reset.pressed
      @reset()
    else
      @car.update(controlStatus)
      @world.Step 1 / 60, 10, 10
      @world.DrawDebugData()
      @world.ClearForces()

  reset: =>
    @car.reset()


window.Game = Game