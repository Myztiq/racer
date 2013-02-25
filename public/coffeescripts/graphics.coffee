class Graphics

  constructor: ->
    @tracking = {}
    @stage = new createjs.Stage("drawing");

  trackObject: (easelObject, box2dObject, isCameraObject=false)=>
    if isCameraObject
      @cameraObj = box2dObject
    trackingID = Math.random()
    @tracking[trackingID] =
      easel: easelObject
      box2d: box2dObject
    @stage.addChild easelObject

  removeTracking: (id)->


  update: (objToTrack, ctx)=>
    for key, obj of @tracking
      obj.easel.x = obj.box2d.GetWorldCenter().x * scale
      obj.easel.y = obj.box2d.GetWorldCenter().y * scale
      if !obj.easel.regRotation
        obj.easel.regRotation = 0
      obj.easel.rotation = (obj.box2d.GetAngle() + obj.easel.regRotation) * (180 / Math.PI)

    if @cameraObj?
      oldX = @stage.x
      oldY = @stage.y
      @stage.x = @cameraObj.GetPosition().x * -scale + 300
      @stage.y = @cameraObj.GetPosition().y * -scale + 300
      ctx.translate(@stage.x,@stage.y);
    @stage.update()

window.Graphics = Graphics