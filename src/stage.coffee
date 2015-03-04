`import AppearanceDetector from "multiSceneMovie/appearanceDetector"`

class Stage
  constructor: (@element, @appearanceDetectorMarginTop, @appearanceDetectorMarginBottom) ->
    @appearanceDetector = new AppearanceDetector(@element, @appearanceDetectorMarginTop, @appearanceDetectorMarginBottom)

  stageDidAppear: ->

  stageDidDisapper: ->

  detectAppearance: -> @appearanceDetector.detect()

  open: ->
    @detectAppearance()
    @element.classList.remove('hide')

  close: -> @element.classList.add('hide')

  isOpen: -> !@isClose()
  isClose: -> @element.classList.contains('hide')

  isVisible: -> @isOpen() && @appearanceDetector.visible()

`export default Stage`
