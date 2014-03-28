`import AppearanceDetector from "multiSceneMovie/appearanceDetector"`

class Stage
  constructor: (@element) ->
    @ad = new AppearanceDetector(@element)
    @ad.didAppear = @stageDidAppear
    @ad.didDisappear = @stageDidDisappear

  stageDidAppear: ->

  stageDidDisapper: ->

  detectAppearance: -> @ad.detect()

  open: -> @element.classList.remove('hide')
  close: -> @element.classList.add('hide')

  isOpen: -> !@isClose()
  isClose: -> @element.classList.contains('hide')

`export default Stage`
