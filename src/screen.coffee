class Screen
  constructor: (@element) ->
    @setDefaultImage()

  setStrips: (@strips) -> @currentStipIndex = 0

  setDefaultImage: ->
    if @defaultImageUrl()
      defaultStyle = @element.style.cssText
      @element.style.cssText = defaultStyle + "background-image: url(#{@defaultImageUrl()}); background-size: cover;　background-repeat: no-repeat;"

  defaultImageUrl: ->
    url = @element.dataset["defaultImage"]
    if url == ""
      undefined
    else
      url

  showCurrentFrame: ->
    @fitCssToCurrentFrame() unless @element.style.backgroundImage
    @element.style.backgroundPosition = @currentStrip().currentFrame().backgroundPositionText()

  currentStrip: -> @strips[@currentStipIndex]

  moveFrameToNext: ->
    @moveStripToNext() if @currentStrip().isAtLastFrame()
    @currentStrip().moveFrameToNext()

  moveStripToNext: ->
    @currentStrip().frameIndex = 0
    @currentStipIndex++ unless @currentStrip() == @strips[@strips.length - 1]
    @fitCssToCurrentFrame()

  fitCssToCurrentFrame: ->
    defaultStyle = @element.style.cssText
    @element.style.cssText = defaultStyle + "background-image: url(#{@currentStrip().image_uri}); background-size: cover;　background-repeat: no-repeat;"

  moveFrameToFirst: ->
    @currentStipIndex = 0
    @currentStrip().frameIndex = 0
    @fitCssToCurrentFrame()

  isAtFirstFrame: ->
    return false unless @currentStrip() == @strips[0]
    return true if @currentStrip().frameIndex == 0
    false

  isAtLastFrame: ->
    return false unless @currentStrip() == @strips[@strips.length - 1]
    return true if @currentStrip().isAtLastFrame()
    false

`export default Screen`
