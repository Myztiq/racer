// Generated by CoffeeScript 1.3.3
(function() {
  var Track, b2AABB, b2Body, b2BodyDef, b2CircleShape, b2DebugDraw, b2Fixture, b2FixtureDef, b2MassData, b2MouseJointDef, b2PolygonShape, b2Vec2, b2World,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  b2Vec2 = Box2D.Common.Math.b2Vec2;

  b2AABB = Box2D.Collision.b2AABB;

  b2BodyDef = Box2D.Dynamics.b2BodyDef;

  b2Body = Box2D.Dynamics.b2Body;

  b2FixtureDef = Box2D.Dynamics.b2FixtureDef;

  b2Fixture = Box2D.Dynamics.b2Fixture;

  b2World = Box2D.Dynamics.b2World;

  b2MassData = Box2D.Collision.Shapes.b2MassData;

  b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;

  b2CircleShape = Box2D.Collision.Shapes.b2CircleShape;

  b2DebugDraw = Box2D.Dynamics.b2DebugDraw;

  b2MouseJointDef = Box2D.Dynamics.Joints.b2MouseJointDef;

  Track = (function() {

    function Track(world, graphics) {
      this.initGraphics = __bind(this.initGraphics, this);

      var bodyDef, fixDef;
      fixDef = new b2FixtureDef;
      fixDef.density = 1.0;
      fixDef.friction = 0.5;
      fixDef.restitution = 0.2;
      bodyDef = new b2BodyDef;
      bodyDef.type = b2Body.b2_staticBody;
      fixDef.shape = new b2PolygonShape;
      fixDef.shape.SetAsBox(200, 2);
      bodyDef.position.Set(10, 400 / 30 + 1.8);
      this.ground = world.CreateBody(bodyDef);
      this.ground.CreateFixture(fixDef);
      this.initGraphics(graphics);
    }

    Track.prototype.initGraphics = function(graphics) {
      var body;
      body = new createjs.Shape();
      body.graphics.beginLinearGradientFill(["#000", "#FFF"], [0, 1], 0, 0, 200 * scale, 0).drawRoundRect(0, 0, 200 * scale * 2, 2 * scale * 2, 5);
      body.regX = 200 * scale;
      body.regY = 2 * scale;
      return graphics.trackObject(body, this.ground);
    };

    return Track;

  })();

  window.Track = Track;

}).call(this);
