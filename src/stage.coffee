class Stage
  constructor: (@element) ->

  stageDidAppear: ->

  stageDidDisapper: ->

  open: -> @element.classList.remove('hide')
  close: -> @element.classList.add('hide')

`export default Stage`
