`import MultiSceneMovie from "multiSceneMovie/multiSceneMovie"`
`import EventEmitter from "multiSceneMovie/eventEmitter"`

class MasterCompanionMovie
  constructor: (masterRootElement, companionRootElement, appearanceDetectorMarginTop=0, appearanceDetectorMarginBottom=0) ->
    @masterMovie = new MultiSceneMovie(masterRootElement, appearanceDetectorMarginTop, appearanceDetectorMarginBottom)
    @companionMovie = new MultiSceneMovie(companionRootElement, appearanceDetectorMarginTop, appearanceDetectorMarginBottom)

    @composeMovies()

    @masterMovie.bindEvent("movie:started", => @triggerEvent("movie:started"))
    @masterMovie.bindEvent("movie:finished", => @triggerEvent("movie:finished"))
    @masterMovie.bindEvent("movie:played:firstQuartile", => @triggerEvent("movie:played:firstQuartile"))
    @masterMovie.bindEvent("movie:played:half", => @triggerEvent("movie:played:half"))
    @masterMovie.bindEvent("movie:played:thirdQuartile", => @triggerEvent("movie:played:thirdQuartile"))

    @companionMovie.bindEvent("movie:finished", => @triggerEvent("movie:finished"))
    @companionMovie.bindEvent("movie:played:firstQuartile", => @triggerEvent("movie:played:firstQuartile"))
    @companionMovie.bindEvent("movie:played:half", => @triggerEvent("movie:played:half"))
    @companionMovie.bindEvent("movie:played:thirdQuartile", => @triggerEvent("movie:played:thirdQuartile"))

  bindEvent: (eventName, callback) -> getEventEmitter().listen(eventName, callback)

  triggerEvent: (eventName) -> getEventEmitter().emit(eventName)

  composeMovies: () ->
    @masterMovie.bindEvent("movie:loaded", () =>
      @companionMovie.startScenes()
    )

    @masterMovie.bindEvent("movie:paused", (callbackData) =>
      @companionMovie.playMovieAtIndex(callbackData.detail.index)
      @companionMovie.triggerEvent("movie:play")
    )

  getEventEmitter = () -> new EventEmitter(document.getElementsByTagName("body")[0])

  start: () -> @masterMovie.startScenes()

`export default MasterCompanionMovie`
