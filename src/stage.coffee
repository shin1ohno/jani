`import AppearanceDetector from "multiSceneMovie/appearanceDetector"`

class Stage
  constructor: (@element) ->
    @appearanceDetector = new AppearanceDetector(@element)

  stageDidAppear: ->

  stageDidDisapper: ->

  detectAppearance: -> @appearanceDetector.detect()

  open: ->
    @detectAppearance()
    @element.classList.remove('hide')

  close: -> @element.classList.add('hide')

  isOpen: -> !@isClose()
  isClose: -> @element.classList.contains('hide')

`export default Stage`
