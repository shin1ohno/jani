`import FrameRectangle from "multiSceneMovie/frameRectangle"`

class Strip
  constructor: (@image_uri, @frameWidth, @frameHeight, @framesCount, @element) ->
    @initializeStyles()
    @initializeFrames()
    @initializeStripImages()

  initializeStyles: ->
    @element.style.position = "absolute"

  initializeFrames: ->
    @frames = []
    @frames.push(new FrameRectangle(0,  @frameHeight * frameIndex)) for frameIndex in [0..(@framesCount - 1)]
    @frameIndex = 0

  initializeStripImages: ->
    @stripImageElement = @element.getElementsByTagName("img")[0]
    @stripImageElement.style.width = "#{@frameWidth}px"
    @stripImageElement.style.height = "#{@frameHeight * @framesCount}px"

  currentFrame: -> @frames[@frameIndex]

  moveFrameToNext: -> @frameIndex++

  isAtLastFrame: -> @frameIndex == @framesCount - 1

  stripImageDidLoad: ->

  loadStripImage: ->
    @stripImageElement.addEventListener("load", @stripImageDidLoad, false)
    @stripImageElement.src = @image_uri

  activate: -> @element.classList.remove('hide')

  deactivate: -> @element.classList.add('hide')

  moveToCurrentFrame: ->
    @element.style.top = "#{@currentFrame().topPosition * -1}px"
    @element.style.left = "#{@currentFrame().leftPosition * -1}px"

  resetFrame: ->
    @frameIndex = 0
    @moveToCurrentFrame()

`export default Strip`
