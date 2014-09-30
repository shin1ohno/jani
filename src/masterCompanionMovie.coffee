`import EventEmitter from "multiSceneMovie/eventEmitter"`
`import MultiSceneMovie from "multiSceneMovie/multiSceneMovie"`

class MasterCompanionMovie
  constructor: (masterRootElement, companionRootElement, appearanceDetectorMarginTop=0, appearanceDetectorMarginBottom=0) ->
    @masterMovie = new MultiSceneMovie(masterRootElement, appearanceDetectorMarginTop, appearanceDetectorMarginBottom)
    @companionMovie = new MultiSceneMovie(companionRootElement, appearanceDetectorMarginTop, appearanceDetectorMarginBottom)

    @composeMovies()

  composeMovies: () ->
    @masterMovie.bindEvent("movie:loaded", () =>
      @companionMovie.startScenes()
    )

    @masterMovie.bindEvent("movie:paused", (callbackData) =>
      @companionMovie.playMovieAtIndex(callbackData.detail.index)
      @companionMovie.triggerEvent("movie:play")
    )

  getEventEmitter = () -> new EventEmitter(document.getElementsByTagName("script")[0])

  start: () -> @masterMovie.startScenes()

`export default MasterCompanionMovie`
