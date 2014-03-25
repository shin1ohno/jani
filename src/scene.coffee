class Scene
  constructor: (@stage) ->

  sceneDidStart: ->
  sceneDidFinish: ->

  start: =>
    @stage.open()
    @sceneDidStart()

  finish: =>
    @stage.close()
    @sceneDidFinish()

`export default Scene`
