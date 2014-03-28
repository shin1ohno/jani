class Screen
  constructor: (@element) ->
    @setDefaultImage()

  setStrips: (@strips) ->
    @currentStipIndex = 0

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
    defaultStyle = @element.style.cssText
    @element.style.cssText = defaultStyle + @currentStrip().toCssText()

  currentStrip: -> @strips[@currentStipIndex] #TODO: implement multi strip

  moveFrameToNext: -> @currentStrip().moveFrameToNext()

  moveFrameToFirst: ->
    @currentStipIndex = 0
    @currentStrip().frameIndex = 0

  isAtFirstFrame: ->
    return false unless @currentStrip() == @strips[0]
    return true if @currentStrip().frameIndex == 0
    false

  isAtLastFrame: ->
    return false unless @currentStrip() == @strips[@strips.length - 1]
    return true if @currentStrip().isAtLastFrame()
    false

`export default Screen`
