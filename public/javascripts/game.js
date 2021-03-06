// Generated by CoffeeScript 1.3.3
(function() {
  var Game, b2DebugDraw, b2Vec2, b2World,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  b2Vec2 = Box2D.Common.Math.b2Vec2;

  b2World = Box2D.Dynamics.b2World;

  b2DebugDraw = Box2D.Dynamics.b2DebugDraw;

  window.scale = 20.0;

  Game = (function() {

    function Game() {
      this.reset = __bind(this.reset, this);

      this.update = __bind(this.update, this);

      var context, debugDraw;
      this.graphics = new Graphics();
      this.controls = new Controls();
      this.world = new b2World(new b2Vec2(0, 10), true);
      this.track = new Track(this.world, this.graphics);
      this.car = new Car(this.world, this.graphics);
      this.$canvas = $('#canvas')[0];
      this.ctx = $('#canvas')[0].getContext('2d');
      debugDraw = new b2DebugDraw();
      debugDraw.SetSprite(document.getElementById("canvas").getContext("2d"));
      debugDraw.SetDrawScale(scale);
      debugDraw.SetFillAlpha(0.5);
      debugDraw.SetLineThickness(1.0);
      debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
      this.world.SetDebugDraw(debugDraw);
      window.setInterval(this.update, 1000 / 60);
      context = $('#canvas')[0].getContext('2d');
    }

    Game.prototype.update = function() {
      var controlStatus;
      controlStatus = this.controls.getControlStatus();
      if (controlStatus.reset.pressed) {
        this.reset();
      }
      this.$canvas.width = this.$canvas.width;
      this.graphics.update(this.car, this.ctx);
      this.world.DrawDebugData();
      this.car.update(controlStatus);
      this.track.update();
      this.world.Step(1 / 60, 10, 10);
      return this.world.ClearForces();
    };

    Game.prototype.reset = function() {
      this.track.reset();
      return this.car.reset();
    };

    return Game;

  })();

  window.Game = Game;

}).call(this);
