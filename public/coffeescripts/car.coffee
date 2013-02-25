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
b2PrismaticJoint = Box2D.Dynamics.Joints.b2PrismaticJointDef
b2RevoluteJointDef = Box2D.Dynamics.Joints.b2RevoluteJointDef

startPosition =
  x: 10
  y: 10
  angle: Math.PI

class Car
  constructor: (world, graphics)->
    boxDef = new b2FixtureDef
    boxDef.density = 1.0
    boxDef.friction = 0.5
    boxDef.restitution = 0.01
    boxDef.filter.groupIndex = -1

    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position.x = startPosition.x
    bodyDef.position.y = startPosition.y
    bodyDef.angle = startPosition.angle

    # Make Car
    @carBody = car = world.CreateBody(bodyDef)

    boxDef.shape = new b2PolygonShape
    boxDef.shape.SetAsBox 1.5, 0.3
    car.CreateFixture boxDef

    boxDef.shape.SetAsOrientedBox(0.4, 0.15, new b2Vec2(-1, -0.3), Math.PI / 3)
    car.CreateFixture boxDef

    boxDef.shape.SetAsOrientedBox(0.4, 0.15, new b2Vec2(1, -0.3), -Math.PI / 3)
    car.CreateFixture boxDef

    boxDef.density = 1

    # Make Axels
    @axle1 = axle1 = world.CreateBody(bodyDef)
    boxDef.shape.SetAsOrientedBox(0.4, 0.1, new b2Vec2(-1 - 0.6*Math.cos(Math.PI / 3), -0.3 - 0.6*Math.sin(Math.PI / 3)), Math.PI / 3)
    axle1.CreateFixture boxDef

    @axle2 = axle2 = world.CreateBody(bodyDef)
    boxDef.shape.SetAsOrientedBox(0.4, 0.1, new b2Vec2(1 + 0.6*Math.cos(-Math.PI / 3), -0.3 + 0.6*Math.sin(-Math.PI / 3)), -Math.PI / 3)
    axle2.CreateFixture boxDef

    # Make Joints
    prismaticJointDef = new b2PrismaticJoint()
    prismaticJointDef.Initialize(car, axle1, axle1.GetWorldCenter(), new b2Vec2(Math.cos(Math.PI / 3), Math.sin(Math.PI / 3)))
    prismaticJointDef.lowerTranslation = -0.3
    prismaticJointDef.upperTranslation = 0.5
    prismaticJointDef.enableLimit = true
    prismaticJointDef.enableMotor = true
    @spring1 = world.CreateJoint(prismaticJointDef)

    prismaticJointDef.Initialize(car, axle2, axle2.GetWorldCenter(), new b2Vec2(-Math.cos(Math.PI / 3), Math.sin(Math.PI / 3)))
    @spring2 = world.CreateJoint(prismaticJointDef)

    # Add Wheels
    circleDef = new b2FixtureDef
    circleDef.radius = 0.7
    circleDef.density = 0.1
    circleDef.friction = 5
    circleDef.restitution = 0.2
    circleDef.filter.groupIndex = -1
    circleDef.shape = new b2CircleShape(.7)


    bodyDef.allowSleep = false

    # Make wheel 1
    bodyDef.position.Set axle1.GetWorldCenter().x + 0.3*Math.cos(Math.PI / 3), axle1.GetWorldCenter().y + 0.3*Math.sin(Math.PI / 3)
    @wheel1 = wheel1 = world.CreateBody(bodyDef)
    wheel1.CreateFixture circleDef

    # Make wheel 2
    bodyDef.position.Set axle2.GetWorldCenter().x - 0.3*Math.cos(-Math.PI / 3), axle2.GetWorldCenter().y - 0.3*Math.sin(-Math.PI / 3)
    @wheel2 = wheel2 = world.CreateBody(bodyDef)
    wheel2.CreateFixture circleDef


    #Connect the wheels to the body
    revoluteJointDef = new b2RevoluteJointDef()
    revoluteJointDef.enableMotor = true
    revoluteJointDef.Initialize(axle1, wheel1, wheel1.GetWorldCenter())
    @motor1 = world.CreateJoint(revoluteJointDef)

    revoluteJointDef.Initialize(axle2, wheel2, wheel2.GetWorldCenter())
    @motor2 = world.CreateJoint(revoluteJointDef)

    @initGraphics(graphics)

  initGraphics: (graphics)=>
    body = new createjs.Shape();
    body.graphics.beginFill("green").drawRoundRect(0, 0, .8*scale*2, 0.1*scale*2, 5);
    body.regRotation = Math.PI / 3
    body.regX = .8*scale;
    body.regY = .1*scale;
    graphics.trackObject(body, @axle1)

    body = new createjs.Shape();
    body.graphics.beginFill("green").drawRoundRect(0, 0, .8*scale*2, 0.1*scale*2, 5);
    body.regRotation = -Math.PI / 3
    body.regX = .8*scale;
    body.regY = .1*scale;
    graphics.trackObject(body, @axle2)

    body = new createjs.Shape();
    body.graphics.beginLinearGradientFill(["#000","#FFF"], [0, 1], 0, 0, .7*scale, 0).drawCircle(0, 0, .7*scale);
    graphics.trackObject(body, @wheel1)

    body = new createjs.Shape();
    body.graphics.beginLinearGradientFill(["#000","#FFF"], [0, 1], 0, 0, .7*scale, 0).drawCircle(0, 0, .7*scale);
    graphics.trackObject(body, @wheel2)

    body = new createjs.Shape();
    body.graphics.beginFill("red").drawRoundRect(0, 0, 1.5*scale*2, 0.3*scale*2, 5);
    body.regX = 1.5*scale;
    body.regY = .3*scale;
    graphics.trackObject(body, @carBody, true)


  reset: =>
    @carBody.SetPositionAndAngle(new b2Vec2(startPosition.x,  startPosition.y),  startPosition.angle)
    @carBody.SetLinearVelocity(new b2Vec2(0,0))
    @carBody.SetAngularVelocity(0)

  update: (controls)=>
    tension = 300
    @spring1.SetMaxMotorForce(30+Math.abs(tension*Math.pow(@spring1.GetJointTranslation(), 2)));
    @spring1.SetMotorSpeed((@spring1.GetMotorSpeed() - 10*@spring1.GetJointTranslation())*0.4);

    @spring2.SetMaxMotorForce(20+Math.abs(tension*Math.pow(@spring2.GetJointTranslation(), 2)));
    @spring2.SetMotorSpeed(-4*Math.pow(@spring2.GetJointTranslation(), 1));


    direction = 0
    if controls.forward.down
      direction = -1

    if controls.backward.down
      direction = 1

    if controls.forward.down and controls.backward.down
      direction = 0

    torque = 17
    if direction == 0
      torque = .5

    @motor1.SetMotorSpeed(15*Math.PI * direction);
    @motor1.SetMaxMotorTorque(torque);

    @motor2.SetMotorSpeed(15*Math.PI * direction);
    @motor2.SetMaxMotorTorque(torque);

window.Car = Car