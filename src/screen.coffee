class Screen
  constructor: (@element) ->
    @element.style.position = "relative"
    @element.style.overflow = "hidden"
    @setDefaultImage()

  setStrips: (@strips) ->
    @currentStipIndex = 0
    @currentStrip().activate()

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

  showCurrentFrame: -> @currentStrip().moveToCurrentFrame()

  currentStrip: -> @strips[@currentStipIndex]

  moveFrameToNext: ->
    @moveStripToNext() if @currentStrip().isAtLastFrame()
    @currentStrip().moveFrameToNext()

  moveStripToNext: ->
    @currentStrip().resetFrame()
    @currentStrip().deactivate()
    @currentStipIndex++ unless @currentStrip() == @strips[@strips.length - 1]
    @currentStrip().resetFrame()
    @currentStrip().activate()

  moveFrameToFirst: ->
    @currentStipIndex = 0
    @currentStrip().frameIndex = 0
    @currentStrip().moveToCurrentFrame()

  isAtFirstFrame: ->
    return false unless @currentStrip() == @strips[0]
    return true if @currentStrip().frameIndex == 0
    false

  isAtLastFrame: ->
    return false unless @currentStrip() == @strips[@strips.length - 1]
    return true if @currentStrip().isAtLastFrame()
    false

`export default Screen`
