b2Vec2 = Box2D.Common.Math.b2Vec2
b2AABB = Box2D.Collision.b2AABB
b2BodyDef = Box2D.Dynamics.b2BodyDef
b2Body = Box2D.Dynamics.b2Body
b2FixtureDef = Box2D.Dynamics.b2FixtureDef
b2Fixture = Box2D.Dynamics.b2Fixture
b2World = Box2D.Dynamics.b2World
b2MassData = Box2D.Collision.Shapes.b2MassData
b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
b2DebugDraw = Box2D.Dynamics.b2DebugDraw
b2MouseJointDef = Box2D.Dynamics.Joints.b2MouseJointDef

getRandomArbitary = (min, max)->
  Math.random() * (max - min) + min;

class Track
  constructor: (@world, @graphics)->
    @obstacles = []
    @loadQueue = []
    @img = new Image();
    @img.src="/images/brick.jpg";
    @img.onload = =>
      @loaded = true
      for queued in @loadQueue
        @drawObj(queued.obj, queued.track)

    customDrawData =
      x: 0
      y: 13
      angle: 0
      length: 20
      right:
        x: 20
        y: 0
      left:
        x: 0
        y: 0

    ramp = @addPhysicsObj(customDrawData)
    @addObstacle(customDrawData)
    @drawObj(customDrawData, ramp)

  drawObj: (obj, track)=>
    if @loaded
      body = new createjs.Shape();
      body.graphics.beginBitmapFill(@img).drawRoundRect(0, 0, obj.length*scale*2, 10*scale*2, 5);
      body.regX = obj.length*scale;
      body.regY = .2*scale;
      @graphics.trackObject(body, track)
    else
      @loadQueue.push
        obj: obj
        track: track

  addPhysicsObj: (customDrawData)->
    # Create the shape!
    fixDef = new b2FixtureDef
    fixDef.shape = new b2PolygonShape
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_staticBody
    fixDef.shape.SetAsBox customDrawData.length,.2
    bodyDef.position.Set customDrawData.x, customDrawData.y

    ramp = @world.CreateBody(bodyDef)
    ramp.CreateFixture fixDef
    ramp.SetAngle(customDrawData.angle / (180 / Math.PI))
    ramp


  addObstacle: (lastObjData)->
    maxAngle = 40
    minAngle = maxAngle*-1
    maxAngleDifference = 30
    maxLength = 15
    minLength = 2

    # prevent angle from changing direction too much
    newAngle = getRandomArbitary(maxAngle, minAngle)
    oldAngle = lastObjData.angle

    difference = 0
    if newAngle > oldAngle
      difference = newAngle - oldAngle
      if difference > maxAngleDifference
        newAngle = oldAngle + maxAngleDifference
    else
      difference = oldAngle - newAngle
      if difference > maxAngleDifference
        newAngle = oldAngle - maxAngleDifference


    customDrawData =
      length: getRandomArbitary(maxLength, minLength)
      angle: newAngle

    customDrawData.left =
      x: (customDrawData.length) * Math.cos(customDrawData.angle / (180 / Math.PI)) * -1
      y: (customDrawData.length) * Math.sin(customDrawData.angle / (180 / Math.PI)) * -1

    customDrawData.right =
      x: (customDrawData.length) * Math.cos(customDrawData.angle / (180 / Math.PI))
      y: (customDrawData.length) * Math.sin(customDrawData.angle / (180 / Math.PI))

    customDrawData.x = lastObjData.right.x + lastObjData.x + -1*customDrawData.left.x
    customDrawData.y = lastObjData.right.y + lastObjData.y + -1*customDrawData.left.y


    ramp = @addPhysicsObj(customDrawData)
    @obstacles.push customDrawData
    @drawObj(customDrawData, ramp)


  # This get's called at every tick
  debugged = 0
  update: =>
    # Get the car's position, figure out if we need to draw the next block
    carPosition = game.car.carBody.GetWorldCenter()
    # Get the end of our last drawn obstacle
    lastObstacle = @obstacles[@obstacles.length-1]
    if carPosition.x+20 > lastObstacle.x
      @addObstacle(lastObstacle)

window.Track = Track


