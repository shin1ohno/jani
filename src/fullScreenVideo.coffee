`import EventEmitter from "multiSceneMovie/eventEmitter"`

class FullscreenVideo
  constructor: (sourceUrl, wrapperElement) ->
    @videoElement = document.createElement("video")
    @videoElement.src = sourceUrl
    @eventEmitter = new EventEmitter(wrapperElement)
    wrapperElement.appendChild(setStyles(@videoElement))
    setEvents(@videoElement, this)

  play: ->
    enterFullScreen(@videoElement)
    @videoElement.play()
    return this

  pause: -> @videoElement.pause()

  bindEvent: (eventName, callback) -> @eventEmitter.listen(eventName, callback)

  triggerEvent: (eventName) -> @eventEmitter.emit(eventName)

  setStyles = (videoElement) ->
    videoElement.preload = "metadata"
    videoElement.style.width = "1px"
    videoElement.style.height = "1px"
    videoElement.style.position = "absolute"
    videoElement.style.top = "0px"
    videoElement.style.left = "0px"
    return videoElement

  setEvents = (videoElement, fullscreenVideo) ->
    changeHandler = ->
      isPlayingFullScreen = false
      if typeof document.isFullScreen != "undefined"
        isPlayingFullScreen = document.isFullScreen
      else if typeof document.fullScreen != "undefined"
        isPlayingFullScreen = document.fullScreen
      else if typeof document.webkitIsFullScreen != "undefined"
        isPlayingFullScreen = document.webkitIsFullScreen
      if isPlayingFullScreen
        fullscreenVideo.triggerEvent("movie:fullscreen")
      else
        fullscreenVideo.triggerEvent("movie:exitFullscreen")

    for eventName in ("webkitfullscreenchange fullscreenchange").split(" ")
      videoElement.addEventListener(eventName, changeHandler, false)

    videoElement.addEventListener("webkitbeginfullscreen", ->
      fullscreenVideo.triggerEvent("movie:fullscreen")
    , false)

    videoElement.addEventListener("webkitendfullscreen", ->
      fullscreenVideo.triggerEvent("movie:exitFullscreen")
    , false)

    fullscreenVideo.bindEvent("movie:tryFullscreen", -> fullscreenVideo.play())
    fullscreenVideo.bindEvent("movie:exitFullscreen", -> fullscreenVideo.pause())

  enterFullScreen = (videoElement) ->
    return videoElement.requestFullscreen() if videoElement.requestFullscreen
    return videoElement.msRequestFullscreen() if videoElement.msRequestFullscreen
    return videoElement.mozRequestFullScreen() if videoElement.mozRequestFullScreen
    return videoElement.webkitRequestFullscreen() if videoElement.webkitRequestFullscreen
    return videoElement.webkitEnterFullscreen() if videoElement.webkitEnterFullscreen

`export default FullscreenVideo`
