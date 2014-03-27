`import Stage from "multiSceneMovie/stage"`
`import AppearanceDetector from "multiSceneMovie/appearanceDetector"`

class MovieStage extends Stage
  constructor: (@movie) ->
    @element = @movie.screen.element
    @ad = new AppearanceDetector(@element)
    @ad.didAppear = @stageDidAppear
    @ad.didDisappear = @stageDidDisappear
    @movie.play() if @detectAppearance()

  stageDidAppear: =>
    @movie.play()

  stageDidDisappear: =>
    @movie.pause()

  detectAppearance: =>
    @ad.detect()

`export default MovieStage`
