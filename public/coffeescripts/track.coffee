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

class Track
  constructor: (world, graphics)->
    fixDef = new b2FixtureDef
    fixDef.density = 1.0
    fixDef.friction = 0.5
    fixDef.restitution = 0.2
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_staticBody
    fixDef.shape = new b2PolygonShape
    fixDef.shape.SetAsBox 200, 2
    bodyDef.position.Set 10, 400 / 30 + 1.8
    @ground = world.CreateBody(bodyDef)
    @ground.CreateFixture fixDef


    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_staticBody
    fixDef.shape.SetAsBox 10,.2
    fixDef.shape.SetAsOrientedBox(10, .2, new b2Vec2(0,0), -Math.PI / 4)
    bodyDef.position.Set 15,14
    @ramp = world.CreateBody(bodyDef)
    @ramp.CreateFixture fixDef
    @initGraphics(graphics)

  initGraphics: (graphics)=>
    body = new createjs.Shape();
    img = new Image();
    img.src="/images/brick.jpg";
    img.onload= =>
      body.graphics.beginBitmapFill(img).drawRoundRect(0, 0, 200*scale*2, 2*scale*2, 5);
      body.regX = 200*scale;
      body.regY = 2*scale;
      graphics.trackObject(body, @ground)

window.Track = Track


