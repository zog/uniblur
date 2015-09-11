class window.PictureUploader
  constructor: (el)->
    @el = $(el)
    @workshop = $(".workshop")
    @startBt = $('#start')
    @imgUrlField = @el.find('[name="picture[remote_image_url]"]')
    @resetBt = @el.find(".btn.reset")
    @resetBt.click =>
      @reset()
    @resetBt.hide()
    @imgUrlField.change =>
      @updateImage()

    @inputs = @el.find('input.required, input[name*="remote_image_url"]')
    @inputs.on "change", (e)=>
      if $(e.target).val()?
        @removeErrors e.target
      else
        @addErrors e.target

    @startBt.click =>
      @startBt.addClass 'done'
      @workshop.addClass('active')
      $('.page').animate
        scrollTop: @el.offset().top
      , 1000
      setTimeout =>
        @startBt.remove()
        $(@el.find('.picture_image label')[0]).trigger 'click'
      , 700

    @el.on 'submit', (e) =>
      @errors = false
      for f in @inputs
        unless $(f).val()
          @errors = true
          @addErrors f

      return false if @errors
      @stage.removeChild @cursor
      @stage.update()
      @el.find('[name*=image_data]').val @stage.toDataURL()
      @el.find('[name*=remote_image_url]').remove()
    # @imgUrlField.val('http://uniblur.s3-eu-west-1.amazonaws.com/uploads%2F80258f01-85d1-44ec-84aa-16d9fd862c9e%2Fzog.jpg').trigger 'change'
    # @imgUrlField.val('http://uniblur.s3-eu-west-1.amazonaws.com/uploads%2F8f1d7e98-4ac9-4413-a35a-218ca959f504%2Fmasque_affiche_portrait.jpg').trigger 'change'
    # @startBt.click()

  addErrors: (f)->
    $(f).parents('.form-group').addClass 'has-error'
    parent = $(f).parent()
    feedback = $('<span class="form-control-feedback"><i class="fa fa-times"></i> </span>')
    feedback.appendTo parent
    alert = $('<span class="alert alert-danger">This field is mandatory</span>')
    alert.appendTo parent

  removeErrors: (f)->
    $(f).parents('.form-group').removeClass 'has-error'
    parent = $(f).parent()
    parent.find('.form-control-feedback, .alert').remove()

  buildWorkzone: =>
    return if @workzone?
    @workzone = $('<div></div>')
    @workzone.addClass 'workzone workshop-working-container'
    @workzone.appendTo @el.find('.right')
    @loader = $('<img class="loader" src="/assets/diamond-red.png"></canvas>')
    @loader.appendTo @workzone
    @canvas = $('<canvas></canvas>')
    @canvas.appendTo @workzone

  handleComplete: =>
    $img = $(@img)
    $img.appendTo $("body")
    @originalWidth = $img.width()
    @originalHeight = $img.height()
    @loader.remove()
    $img.appendTo @workzone
    @canvas.attr 'width', $img.width()
    @canvas.attr 'height', $img.height()
    @stage = new createjs.Stage(@canvas[0])

    @stage.addEventListener("stagemousedown", @handleMouseDown)
    @stage.addEventListener("stagemouseup", @handleMouseUp)
    @stage.addEventListener("stagemousemove", @handleMouseMove)

    @bitmap = new createjs.Bitmap(@img)
    @blur = new createjs.Bitmap(@img)

    @bitmap.scaleX = @blur.scaleX = $img.width() / @originalWidth
    @bitmap.scaleY = @blur.scaleY = $img.height() / @originalHeight

    @stage.addChild(@bitmap, @blur)
    @drawingCanvas = new createjs.Shape()
    # $img.remove()
    @cursor = new createjs.Shape(new createjs.Graphics().beginFill("#FFFFFF").drawCircle(0, 0, 25))
    @cursor.cursor = "pointer"

    @stage.addChild(@cursor)
    @updateCacheImage false

  updateCacheImage: (update)=>
    if update
      @drawingCanvas.updateCache()
    else
      @drawingCanvas.cache 0, 0, @originalWidth, @originalHeight

    blurFilter = new createjs.BlurFilter(24, 24, 2)
    # blurFilter = new createjs.ColorFilter(0,0,0,1, 0,0,255,0)
    maskFilter = new createjs.AlphaMaskFilter(@drawingCanvas.cacheCanvas)
    @blur.filters = [blurFilter, maskFilter];
    if update
      @blur.updateCache(0, 0, @originalWidth, @originalHeight)
    else
      @blur.cache(0, 0, @originalWidth, @originalHeight)

    @stage.update()

  updateImage: =>
    @el.find('.picture_image').hide()
    @buildWorkzone()
    if @img?
      $(@img).remove()
    @img = new Image()
    @img.crossOrigin = "Anonymous"
    @img.onload = @handleComplete
    @img.src = @imgUrlField.val()

  reset: =>
    @stage.removeChild @drawingCanvas
    @drawingCanvas = new createjs.Shape()
    @stage.addChild @drawingCanvas
    @updateCacheImage(false)
    @resetBt.hide()

  handleMouseDown: (event)=>
    @oldPt = new createjs.Point(@stage.mouseX / @bitmap.scaleX, @stage.mouseY / @bitmap.scaleY)
    @oldMidPt = @oldPt
    @isDrawing = true
    @drawingCanvasTmp = new createjs.Shape()
    @drawingCanvasTmp.scaleX = @bitmap.scaleX
    @drawingCanvasTmp.scaleY = @bitmap.scaleY
    @drawingCanvasTmp.alpha = 0.5
    @stage.addChild(@drawingCanvasTmp)

  handleMouseMove: (event)=>
    @cursor.x = @stage.mouseX
    @cursor.y = @stage.mouseY
    if (!@isDrawing)
      @stage.update()
      return

    midPoint = new createjs.Point(@oldPt.x + @stage.mouseX / @bitmap.scaleX >> 1, @oldPt.y + @stage.mouseY / @bitmap.scaleY >> 1)
    @drawingCanvas.graphics.setStrokeStyle(40 / @bitmap.scaleX, "round", "round")
        .beginStroke("rgba(0,0,0,0.2)")
        .moveTo(midPoint.x, midPoint.y)
        .curveTo(@oldPt.x, @oldPt.y, @oldMidPt.x, @oldMidPt.y)
    @drawingCanvasTmp.graphics.setStrokeStyle(40 / @bitmap.scaleX, "round", "round")
        .beginStroke("rgba(0,0,0,0.2)")
        .moveTo(midPoint.x, midPoint.y)
        .curveTo(@oldPt.x, @oldPt.y, @oldMidPt.x, @oldMidPt.y)
    @oldPt.x = @stage.mouseX / @bitmap.scaleX
    @oldPt.y = @stage.mouseY / @bitmap.scaleY
    @oldMidPt.x = midPoint.x
    @oldMidPt.y = midPoint.y
    # if @bitmap.scaleX < 1 || @bitmap.scaleY < 1
    @stage.update()
    # else
    #   @updateCacheImage(true)

  handleMouseUp: (event)=>
    @resetBt.show()
    @updateCacheImage(true)
    @isDrawing = false
    @stage.removeChild @drawingCanvasTmp

