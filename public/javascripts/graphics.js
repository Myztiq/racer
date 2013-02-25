// Generated by CoffeeScript 1.3.3
(function() {
  var Graphics,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Graphics = (function() {

    function Graphics() {
      this.update = __bind(this.update, this);

      this.trackObject = __bind(this.trackObject, this);
      this.tracking = {};
      this.stage = new createjs.Stage("drawing");
    }

    Graphics.prototype.trackObject = function(easelObject, box2dObject, isCameraObject) {
      var trackingID;
      if (isCameraObject == null) {
        isCameraObject = false;
      }
      if (isCameraObject) {
        this.cameraObj = box2dObject;
      }
      trackingID = Math.random();
      this.tracking[trackingID] = {
        easel: easelObject,
        box2d: box2dObject
      };
      return this.stage.addChild(easelObject);
    };

    Graphics.prototype.removeTracking = function(id) {};

    Graphics.prototype.update = function(objToTrack, ctx) {
      var key, obj, oldX, oldY, _ref;
      _ref = this.tracking;
      for (key in _ref) {
        obj = _ref[key];
        obj.easel.x = obj.box2d.GetWorldCenter().x * scale;
        obj.easel.y = obj.box2d.GetWorldCenter().y * scale;
        if (!obj.easel.regRotation) {
          obj.easel.regRotation = 0;
        }
        obj.easel.rotation = (obj.box2d.GetAngle() + obj.easel.regRotation) * (180 / Math.PI);
      }
      if (this.cameraObj != null) {
        oldX = this.stage.x;
        oldY = this.stage.y;
        this.stage.x = this.cameraObj.GetPosition().x * -scale + 300;
        this.stage.y = this.cameraObj.GetPosition().y * -scale + 300;
        ctx.translate(this.stage.x, this.stage.y);
      }
      return this.stage.update();
    };

    return Graphics;

  })();

  window.Graphics = Graphics;

}).call(this);