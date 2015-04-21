`import EventEmitter from "multiSceneMovie/eventEmitter"`

class FullscreenVideo
  constructor: (sourceUrl, wrapperElement) ->
    @videoElement = document.createElement("video")
    @videoElement.src = sourceUrl
    @videoElement.controls = true
    @eventEmitter = new EventEmitter(wrapperElement)
    videoWrapperElement = document.createElement("div")
    wrapperElement.appendChild(setStyles(@videoElement, videoWrapperElement))
    setEvents(@videoElement, this)

  play: ->
    @videoElement.play()
    enterFullScreen(@videoElement)
    return this

  pause: -> @videoElement.pause()

  bindEvent: (eventName, callback) -> @eventEmitter.listen(eventName, callback)

  triggerEvent: (eventName) -> @eventEmitter.emit(eventName)

  setStyles = (videoElement, videoWrapperElement) ->
    videoElement.preload = "metadata"
    videoElement.style.width = "1px"
    videoElement.style.height = "1px"
    videoElement.style.position = "absolute"
    videoElement.style.top = "0px"
    videoElement.style.left = "0px"
    videoWrapperElement.style.width = "1px"
    videoWrapperElement.style.height = "1px"
    videoWrapperElement.style.position = "absolute"
    videoWrapperElement.style.top = "-9999px"
    videoWrapperElement.style.left = "-9999px"
    videoWrapperElement.style.overflow = "hidden"
    videoWrapperElement.zIndex = 0
    videoWrapperElement.appendChild(videoElement)
    return videoWrapperElement

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
    return videoElement.webkitEnterFullScreen() if videoElement.webkitEnterFullScreen
    return videoElement.webkitEnterFullscreen() if videoElement.webkitEnterFullscreen

`export default FullscreenVideo`
