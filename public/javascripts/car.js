// Generated by CoffeeScript 1.3.3
(function() {
  var Car, b2AABB, b2Body, b2BodyDef, b2CircleShape, b2DebugDraw, b2Fixture, b2FixtureDef, b2MassData, b2MouseJointDef, b2PolygonShape, b2PrismaticJoint, b2RevoluteJointDef, b2Vec2, b2World, startPosition,
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

  b2PrismaticJoint = Box2D.Dynamics.Joints.b2PrismaticJointDef;

  b2RevoluteJointDef = Box2D.Dynamics.Joints.b2RevoluteJointDef;

  startPosition = {
    x: 10,
    y: 10,
    angle: Math.PI
  };

  Car = (function() {

    function Car(world, graphics) {
      this.update = __bind(this.update, this);

      this.reset = __bind(this.reset, this);

      this.initGraphics = __bind(this.initGraphics, this);

      var axle1, axle2, bodyDef, boxDef, car, circleDef, prismaticJointDef, revoluteJointDef, wheel1, wheel2,
        _this = this;
      boxDef = new b2FixtureDef;
      boxDef.density = .8;
      boxDef.friction = 0.5;
      boxDef.restitution = 0.01;
      boxDef.filter.groupIndex = -1;
      bodyDef = new b2BodyDef;
      bodyDef.type = b2Body.b2_dynamicBody;
      bodyDef.position.x = startPosition.x;
      bodyDef.position.y = startPosition.y;
      bodyDef.angle = startPosition.angle;
      this.carBody = car = world.CreateBody(bodyDef);
      boxDef.shape = new b2PolygonShape;
      boxDef.shape.SetAsBox(2.2, .5);
      car.CreateFixture(boxDef);
      boxDef.density = 0;
      boxDef.shape.SetAsOrientedBox(0.8, 0.4, new b2Vec2(-.4, 0.8), 0);
      car.CreateFixture(boxDef);
      boxDef.density = 1;
      this.axle1 = axle1 = world.CreateBody(bodyDef);
      boxDef.shape.SetAsOrientedBox(0.4, 0.1, new b2Vec2(-1 - 0.6 * Math.cos(Math.PI / 3), -0.7 - 0.6 * Math.sin(Math.PI / 3)), Math.PI / 3);
      axle1.CreateFixture(boxDef);
      this.axle2 = axle2 = world.CreateBody(bodyDef);
      boxDef.shape.SetAsOrientedBox(0.4, 0.1, new b2Vec2(1 + 0.6 * Math.cos(-Math.PI / 3), -0.7 + 0.6 * Math.sin(-Math.PI / 3)), -Math.PI / 3);
      axle2.CreateFixture(boxDef);
      prismaticJointDef = new b2PrismaticJoint();
      prismaticJointDef.Initialize(car, axle1, axle1.GetWorldCenter(), new b2Vec2(Math.cos(Math.PI / 3), Math.sin(Math.PI / 3)));
      prismaticJointDef.lowerTranslation = -.7;
      prismaticJointDef.upperTranslation = 0;
      prismaticJointDef.enableLimit = true;
      prismaticJointDef.enableMotor = true;
      this.spring1 = world.CreateJoint(prismaticJointDef);
      prismaticJointDef.Initialize(car, axle2, axle2.GetWorldCenter(), new b2Vec2(-Math.cos(Math.PI / 3), Math.sin(Math.PI / 3)));
      this.spring2 = world.CreateJoint(prismaticJointDef);
      circleDef = new b2FixtureDef;
      circleDef.density = 0.9;
      circleDef.friction = 6;
      circleDef.restitution = .2;
      circleDef.filter.groupIndex = -1;
      circleDef.shape = new b2CircleShape(.7);
      bodyDef.allowSleep = false;
      bodyDef.position.Set(axle1.GetWorldCenter().x + 0.3 * Math.cos(Math.PI / 3), axle1.GetWorldCenter().y + 0.3 * Math.sin(Math.PI / 3));
      this.wheel1 = wheel1 = world.CreateBody(bodyDef);
      wheel1.CreateFixture(circleDef);
      bodyDef.position.Set(axle2.GetWorldCenter().x - 0.3 * Math.cos(-Math.PI / 3), axle2.GetWorldCenter().y - 0.3 * Math.sin(-Math.PI / 3));
      this.wheel2 = wheel2 = world.CreateBody(bodyDef);
      wheel2.CreateFixture(circleDef);
      revoluteJointDef = new b2RevoluteJointDef();
      revoluteJointDef.enableMotor = true;
      revoluteJointDef.Initialize(axle1, wheel1, wheel1.GetWorldCenter());
      this.motor1 = world.CreateJoint(revoluteJointDef);
      revoluteJointDef.Initialize(axle2, wheel2, wheel2.GetWorldCenter());
      this.motor2 = world.CreateJoint(revoluteJointDef);
      this.tire = new Image();
      this.tire.src = '/images/tire.jpg';
      this.tire.onload = function() {
        return _this.initGraphics(graphics);
      };
    }

    Car.prototype.initGraphics = function(graphics) {
      var body;
      body = new createjs.Shape();
      body.graphics.beginFill("green").drawRoundRect(0, 0, .9 * scale * 2, 0.1 * scale * 2, 5);
      body.regRotation = Math.PI / 3;
      body.regX = .5 * scale;
      body.regY = .1 * scale;
      graphics.trackObject(body, this.axle1);
      body = new createjs.Shape();
      body.graphics.beginFill("green").drawRoundRect(0, 0, .9 * scale * 2, 0.1 * scale * 2, 5);
      body.regRotation = -Math.PI / 3;
      body.regX = 1.2 * scale;
      body.regY = .1 * scale;
      graphics.trackObject(body, this.axle2);
      body = new createjs.Shape();
      body.graphics.beginBitmapFill(this.tire).drawCircle(0, 0, .7 * scale);
      graphics.trackObject(body, this.wheel1);
      body = new createjs.Shape();
      body.graphics.beginBitmapFill(this.tire).drawCircle(0, 0, .7 * scale);
      graphics.trackObject(body, this.wheel2);
      body = new createjs.Shape();
      body.graphics.beginFill("red").drawRoundRect(0, 0, 2.2 * scale * 2, 0.5 * scale * 2, 5);
      body.regX = 2.2 * scale;
      body.regY = .5 * scale;
      graphics.trackObject(body, this.carBody, true);
      body = new createjs.Shape();
      body.graphics.beginFill("red").drawRoundRect(0, 0, .8 * scale * 2, 0.4 * scale * 2, 5);
      body.regX = 1.2 * scale;
      body.regY = -.4 * scale;
      return graphics.trackObject(body, this.carBody, true);
    };

    Car.prototype.reset = function() {
      this.carBody.SetPositionAndAngle(new b2Vec2(startPosition.x, startPosition.y), startPosition.angle);
      this.carBody.SetLinearVelocity(new b2Vec2(0, 0));
      this.carBody.SetAngularVelocity(0);
      this.wheel1.SetPositionAndAngle(new b2Vec2(startPosition.x + 1.4, startPosition.y + 1), startPosition.angle);
      this.wheel1.SetLinearVelocity(new b2Vec2(0, 0));
      this.wheel1.SetAngularVelocity(0);
      this.wheel2.SetPositionAndAngle(new b2Vec2(startPosition.x - 1.4, startPosition.y + 1), startPosition.angle);
      this.wheel2.SetLinearVelocity(new b2Vec2(0, 0));
      return this.wheel2.SetAngularVelocity(0);
    };

    Car.prototype.update = function(controls) {
      var direction, force, speed, tension, tilt, tiltTorque, torque;
      tension = 800;
      force = 20;
      speed = 5;
      this.spring1.SetMaxMotorForce(force + Math.abs(tension * Math.pow(this.spring1.GetJointTranslation(), 2)));
      this.spring1.SetMotorSpeed((this.spring1.GetMotorSpeed() - speed * this.spring1.GetJointTranslation()) * 0.4);
      this.spring2.SetMaxMotorForce(force + Math.abs(tension * Math.pow(this.spring2.GetJointTranslation(), 2)));
      this.spring2.SetMotorSpeed((this.spring2.GetMotorSpeed() - speed * this.spring2.GetJointTranslation()) * 0.4);
      direction = 0;
      if (controls.forward.down) {
        direction = -1;
      }
      if (controls.backward.down) {
        direction = 1;
      }
      if (controls.forward.down && controls.backward.down) {
        direction = 0;
      }
      tilt = 0;
      if (controls.leftTilt.down) {
        tilt = -1;
      }
      if (controls.rightTilt.down) {
        tilt = 1;
      }
      if (controls.leftTilt.down && controls.rightTilt.down) {
        tilt = 0;
      }
      torque = 15;
      speed = 10;
      this.motor1.SetMotorSpeed(speed * Math.PI * direction);
      this.motor1.SetMaxMotorTorque(torque);
      this.motor2.SetMotorSpeed(speed * Math.PI * direction);
      this.motor2.SetMaxMotorTorque(torque);
      tiltTorque = 100;
      return this.carBody.ApplyTorque(tiltTorque * tilt);
    };

    return Car;

  })();

  window.Car = Car;

}).call(this);
