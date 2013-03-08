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
    boxDef.density = .8
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
    boxDef.shape.SetAsBox 2.2,.5
    car.CreateFixture boxDef

    boxDef.density = 0
    boxDef.shape.SetAsOrientedBox(0.8, 0.4, new b2Vec2(-.4, 0.8), 0)
    car.CreateFixture boxDef

    boxDef.density = 1

    # Make Axels
    @axle1 = axle1 = world.CreateBody(bodyDef)
    boxDef.shape.SetAsOrientedBox(0.4, 0.1, new b2Vec2(-1 - 0.6*Math.cos(Math.PI / 3), -0.7 - 0.6*Math.sin(Math.PI / 3)), Math.PI / 3)
    axle1.CreateFixture boxDef

    @axle2 = axle2 = world.CreateBody(bodyDef)
    boxDef.shape.SetAsOrientedBox(0.4, 0.1, new b2Vec2(1 + 0.6*Math.cos(-Math.PI / 3), -0.7 + 0.6*Math.sin(-Math.PI / 3)), -Math.PI / 3)
    axle2.CreateFixture boxDef

    # Make Joints
    prismaticJointDef = new b2PrismaticJoint()
    prismaticJointDef.Initialize(car, axle1, axle1.GetWorldCenter(), new b2Vec2(Math.cos(Math.PI / 3), Math.sin(Math.PI / 3)))
    prismaticJointDef.lowerTranslation = -.7
    prismaticJointDef.upperTranslation = 0
    prismaticJointDef.enableLimit = true
    prismaticJointDef.enableMotor = true
    @spring1 = world.CreateJoint(prismaticJointDef)

    prismaticJointDef.Initialize(car, axle2, axle2.GetWorldCenter(), new b2Vec2(-Math.cos(Math.PI / 3), Math.sin(Math.PI / 3)))
    @spring2 = world.CreateJoint(prismaticJointDef)

    # Add Wheels
    circleDef = new b2FixtureDef
    circleDef.density = 0.9
    circleDef.friction = 6
    circleDef.restitution = .2
    circleDef.filter.groupIndex = -1
    circleDef.shape = new b2CircleShape(.7)


    bodyDef.allowSleep = false

    # Make wheel 1
    bodyDef.position.Set axle1.GetWorldCenter().x + 0.3*Math.cos(Math.PI / 3), axle1.GetWorldCenter().y + 0.3*Math.sin(Math.PI / 3)
    @wheel1 = wheel1 = world.CreateBody(bodyDef)
    wheel1.CreateFixture circleDef

    #uncomment to be able to have your wheels be different sizes!
#    circleDef.density = 0.5
#    circleDef.shape = new b2CircleShape(1)

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
    if MODIT?
      @tire = MODIT.getImage('tire')
      @initGraphics(graphics)
    else
      @tire = new Image()
      @tire.src = '/images/tire.jpg'
      @tire.onload = =>
        @initGraphics(graphics)
      

    

  initGraphics: (graphics)=>
    body = new createjs.Shape();
    body.graphics.beginFill("green").drawRoundRect(0, 0, .9*scale*2, 0.1*scale*2, 5);
    body.regRotation = Math.PI / 3
    body.regX = .5*scale;
    body.regY = .1*scale;
    graphics.trackObject(body, @axle1)

    body = new createjs.Shape();
    body.graphics.beginFill("green").drawRoundRect(0, 0, .9*scale*2, 0.1*scale*2, 5);
    body.regRotation = -Math.PI / 3
    body.regX = 1.2*scale;
    body.regY = .1*scale;
    graphics.trackObject(body, @axle2)

    body = new createjs.Shape();
    body.graphics.beginBitmapFill(@tire).drawCircle(0, 0, .7*scale);
    graphics.trackObject(body, @wheel1)

    body = new createjs.Shape();
    body.graphics.beginBitmapFill(@tire).drawCircle(0, 0, .7*scale);
    graphics.trackObject(body, @wheel2)

    body = new createjs.Shape();
    body.graphics.beginFill("red").drawRoundRect(0, 0, 2.2*scale*2, 0.5*scale*2, 5);
    body.regX = 2.2*scale;
    body.regY = .5*scale;
    graphics.trackObject(body, @carBody, {isCameraObject:true})

    body = new createjs.Shape();
    body.graphics.beginFill("red").drawRoundRect(0, 0, .8*scale*2, 0.4*scale*2, 5);
    body.regX = 1.2*scale;
    body.regY = -.4*scale;
    graphics.trackObject(body, @carBody)



  reset: =>
    @carBody.SetPositionAndAngle(new b2Vec2(startPosition.x,  startPosition.y),  startPosition.angle)
    @carBody.SetLinearVelocity(new b2Vec2(0,0))
    @carBody.SetAngularVelocity(0)

    @wheel1.SetPositionAndAngle(new b2Vec2(startPosition.x+1.4,  startPosition.y+1),  startPosition.angle)
    @wheel1.SetLinearVelocity(new b2Vec2(0,0))
    @wheel1.SetAngularVelocity(0)

    @wheel2.SetPositionAndAngle(new b2Vec2(startPosition.x-1.4,  startPosition.y+1),  startPosition.angle)
    @wheel2.SetLinearVelocity(new b2Vec2(0,0))
    @wheel2.SetAngularVelocity(0)
      
      
    @axle1.SetPositionAndAngle(new b2Vec2(startPosition.x,  startPosition.y),  startPosition.angle)
    @axle1.SetLinearVelocity(new b2Vec2(0,0))
    @axle1.SetAngularVelocity(0)
      
      
    @axle2.SetPositionAndAngle(new b2Vec2(startPosition.x,  startPosition.y),  startPosition.angle)
    @axle2.SetLinearVelocity(new b2Vec2(0,0))
    @axle2.SetAngularVelocity(0)
      

  update: (controls)=>
    #Springs
    tension = 800
    force = 20
    speed = 5

    #Wheels
    torque = 15
    speed = 10

    #z/x tilt
    tiltTorque = 100



    @spring1.SetMaxMotorForce(force+Math.abs(tension*Math.pow(@spring1.GetJointTranslation(), 2)));
    @spring1.SetMotorSpeed((@spring1.GetMotorSpeed() - speed*@spring1.GetJointTranslation())*0.4);

    @spring2.SetMaxMotorForce(force+Math.abs(tension*Math.pow(@spring2.GetJointTranslation(), 2)));
    @spring2.SetMotorSpeed((@spring2.GetMotorSpeed() - speed*@spring2.GetJointTranslation())*0.4);


    direction = 0
    if controls.forward.down
      direction = -1

    if controls.backward.down
      direction = 1

    if controls.forward.down and controls.backward.down
      direction = 0

    tilt = 0
    if controls.leftTilt.down
      tilt = -1

    if controls.rightTilt.down
      tilt = 1

    if controls.leftTilt.down and controls.rightTilt.down
      tilt = 0



    @motor1.SetMotorSpeed(speed*Math.PI * direction);
    @motor1.SetMaxMotorTorque(torque);

    @motor2.SetMotorSpeed(speed*Math.PI * direction );
    @motor2.SetMaxMotorTorque(torque);

    @carBody.ApplyTorque(tiltTorque*tilt)

window.Car = Car