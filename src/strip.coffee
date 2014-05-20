`import FrameRectangle from "multiSceneMovie/frameRectangle"`

class Strip
  constructor: (@image_uri, @frameWidth, @frameHeight, @framesCount) ->
    @frames = []
    @frames.push(new FrameRectangle(0, @frameHeight * (@framesCount - frameIndex))) for frameIndex in [0..(@framesCount - 1)]
    @frameIndex = 0

  currentFrame: -> @frames[@frameIndex]

  moveFrameToNext: -> @frameIndex++

  isAtLastFrame: -> @frameIndex == @framesCount - 1

`export default Strip`
