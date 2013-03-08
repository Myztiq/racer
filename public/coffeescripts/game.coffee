b2Vec2 = Box2D.Common.Math.b2Vec2
b2World = Box2D.Dynamics.b2World
b2DebugDraw = Box2D.Dynamics.b2DebugDraw
window.scale = 20.0
class Game

  constructor: ->
    @graphics = new Graphics()
    @controls = new Controls()
    @world = new b2World(new b2Vec2(0, 10), true)

    @track = new Track(@world, @graphics)
    @car = new Car(@world, @graphics)
    @$canvas = $('#canvas')[0]
    @ctx = $('#canvas')[0].getContext('2d')


    debugDraw = new b2DebugDraw()
    debugDraw.SetSprite document.getElementById("canvas").getContext("2d")
    debugDraw.SetDrawScale scale
    debugDraw.SetFillAlpha 0.5
    debugDraw.SetLineThickness 1.0
    debugDraw.SetFlags b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit
    @world.SetDebugDraw debugDraw
    window.setInterval @update, 1000 / 60
    context = $('#canvas')[0].getContext('2d')

  update: =>
    controlStatus = @controls.getControlStatus()
    if controlStatus.reset.pressed
      @reset()
    @$canvas.width = @$canvas.width;
    @graphics.update(@car, @ctx)
    @world.DrawDebugData()
    @car.update(controlStatus)
    @track.update()
    @world.Step 1 / 60, 10, 10
    @world.ClearForces()

  reset: =>
    @track.reset()
    @car.reset()


window.Game = Game