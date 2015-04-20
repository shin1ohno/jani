`import MultiSceneMovie from "multiSceneMovie/multiSceneMovie"`
`import EventEmitter from "multiSceneMovie/eventEmitter"`
`import VastRequest from "multiSceneMovie/vastRequest"`
`import FullscreenVideo from "multiSceneMovie/fullscreenVideo"`

class MasterCompanionMovie
  INTERVAL = 30
  TIMEOUT = 500

  constructor: (masterRootElement, companionRootElement, appearanceDetectorMarginTop=0, appearanceDetectorMarginBottom=0) ->
    @masterMovie = new MultiSceneMovie(masterRootElement, appearanceDetectorMarginTop, appearanceDetectorMarginBottom)
    @companionMovie = new MultiSceneMovie(companionRootElement, appearanceDetectorMarginTop, appearanceDetectorMarginBottom)
    @fullscreenVideoWrapperElement = masterRootElement

    @composeMovies()

    masterRootElement.addEventListener("click", => @triggerEvent("movie:tryFullscreen") if @masterMovie.isPlayingMovie())
    companionRootElement.addEventListener("click", => @triggerEvent("movie:tryFullscreen") if @companionMovie.isPlayingMovie())

    @masterMovie.bindEvent("movie:started", => @triggerEvent("movie:started"))
    @masterMovie.bindEvent("movie:finished", => @triggerEvent("movie:finished"))
    @masterMovie.bindEvent("movie:played:firstQuartile", => @triggerEvent("movie:played:firstQuartile"))
    @masterMovie.bindEvent("movie:played:half", => @triggerEvent("movie:played:half"))
    @masterMovie.bindEvent("movie:played:thirdQuartile", => @triggerEvent("movie:played:thirdQuartile"))
    @masterMovie.bindEvent("movie:loaded", => @triggerEvent("movie:loaded"))
    @masterMovie.bindEvent("movie:clickThrough", => @triggerEvent("movie:clickThrough"))

    @companionMovie.bindEvent("movie:finished", => @triggerEvent("movie:finished"))
    @companionMovie.bindEvent("movie:played:firstQuartile", => @triggerEvent("movie:played:firstQuartile"))
    @companionMovie.bindEvent("movie:played:half", => @triggerEvent("movie:played:half"))
    @companionMovie.bindEvent("movie:played:thirdQuartile", => @triggerEvent("movie:played:thirdQuartile"))
    @companionMovie.bindEvent("movie:clickThrough", => @triggerEvent("movie:clickThrough"))

    @bindEvent("movie:displayContent", =>
      @masterMovie.triggerEvent("movie:displayContent")
      @companionMovie.triggerEvent("movie:displayContent")
    )

    @bindEvent("movie:fullscreen", =>
      @masterMovie.triggerEvent("movie:pause")
      @companionMovie.triggerEvent("movie:pause")
    )

    @trackingsReady = undefined
    @vastRequest = new VastRequest(
        masterRootElement.getElementsByClassName("tracking_events")[0]?.dataset?.vastUrl,
        getEventEmitter(),
        => @trackingsReady = true
      )

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

  setupFullscreenMovie = (sourceUrl, wrapperElement, masterCompanionMovie) ->
    return unless sourceUrl
    fullscreenVideo = new FullscreenVideo(sourceUrl, wrapperElement)
    masterCompanionMovie.bindEvent("movie:tryFullscreen", ->
      fullscreenVideo.triggerEvent("movie:tryFullscreen")
    )
    fullscreenVideo.bindEvent("movie:fullscreen", ->
      masterCompanionMovie.triggerEvent("movie:fullscreen")
    )
    fullscreenVideo.bindEvent("movie:exitFullscreen", ->
      masterCompanionMovie.triggerEvent("movie:displayContent")
      masterCompanionMovie.triggerEvent("movie:exitFullscreen")
    )

  getEventEmitter = () -> new EventEmitter(document.getElementsByTagName("body")[0])

  start: () ->
    @startTime = new Date()
    @_timerId = setInterval(=>
      if @trackingsReady
        mediaUrl = @vastRequest.mediaUrl
        if mediaUrl && mediaUrl != ""
          setupFullscreenMovie(mediaUrl, @fullscreenVideoWrapperElement, this)
        @masterMovie.startScenes()
        clearInterval(@_timerId)
      else
        if ((new Date()) - @startTime) > TIMEOUT
          clearInterval(@_timerId)
          @masterMovie.startScenes()
    , INTERVAL)

`export default MasterCompanionMovie`
