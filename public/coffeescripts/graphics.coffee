class Graphics

  constructor: ->
    @tracking = {}
    @stage = new createjs.Stage("drawing");

  trackObject: (easelObject, box2dObject, {isCameraObject, trackingID} = {})=>
    isCameraObject or= false
    trackingID or= Math.random()

    if isCameraObject
      @cameraObj = box2dObject
    @tracking[trackingID] =
      easel: easelObject
      box2d: box2dObject
    @stage.addChild easelObject
    trackingID

  removeTracking: (id)->
    obj = @tracking[id]
    if obj?
      @stage.removeChild @tracking[id].easel
      delete @tracking[id]
    else
      console.log "Tracking object with ID #{id} does not exist"


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
      @stage.x = @cameraObj.GetPosition().x * -scale + 200
      @stage.y = @cameraObj.GetPosition().y * -scale + 200
      ctx.translate(@stage.x,@stage.y);
    @stage.update()

window.Graphics = Graphics