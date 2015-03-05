`import Beacon from "multiSceneMovie/beacon"`

class VastRequest
  constructor: (@url, @eventEmitter, @callback) ->
    @clickThrough = undefined
    @ready = undefined
    @run() if @url

  valid: ->
    return false unless @url
    return true

  run: -> @requestHandler(@loadWrapperAdIfNeeded)

  loadWrapperAdIfNeeded: (xmlDomTree, callback) =>
    wrappedVASTAd = xmlDomTree.querySelector("Wrapper VASTAdTagURI")
    if wrappedVASTAd
      wrappedVASTAdURI = wrappedVASTAd.textContent
      @xhr = new XMLHttpRequest() unless @xhr
      @xhr.addEventListener("load",
        ((event) =>
          callback(@xhr.responseXML)
          @xhr.removeEventListener("load", arguments, false)
          wrapperVASTImpressionTrackings = xmlDomTree.querySelectorAll("Impression")
          new Beacon(tracking.textContent) for tracking in wrapperVASTImpressionTrackings
        ),
        false
      )
      try
        @xhr.open("GET", wrappedVASTAdURI)
        @xhr.send(null)
      catch e
        # do nothing and ignore errors
    else
      callback(xmlDomTree)

  setTrackers: (xmlDomTree) =>
    return unless xmlDomTree
    trackings = []
    Array.prototype.forEach.call(
      xmlDomTree.querySelectorAll("Linear VideoClicks ClickThrough"),
      (node) ->
        trackings.push({
          event: "clickThrough",
          url: node.textContent,
          type: "img"
        })
    )
    Array.prototype.forEach.call(
      xmlDomTree.querySelectorAll("Linear TrackingEvents Tracking"),
      (node) ->
        trackings.push({
          event: node.getAttribute("event"),
          url: node.textContent,
          type: "img"
        })
    )
    Array.prototype.forEach.call(
      xmlDomTree.querySelectorAll("Impression"),
      (node) ->
        trackings.push({
          event: "impression",
          url: node.textContent,
          type: "img"
        })
    )
    bindTrackingEvent(@eventEmitter, tracking) for tracking in trackings
    @callback() if @callback

  bindTrackingEvent = (eventEmitter, tracking) ->
    return unless eventEmitter
    fromVastEventToJaniEvent = {
      "creativeView": "movie:screen:appeared",
      "impression": "movie:started",
      "firstQuartile": "movie:played:firstQuartile",
      "midpoint": "movie:played:half",
      "thirdQuartile": "movie:played:thirdQuartile",
      "complete": "movie:finished",
      "clickThrough": "movie:clickThrough"
    }
    eventName = fromVastEventToJaniEvent[tracking.event]
    eventEmitter.listen(eventName, -> new Beacon(tracking.url, tracking.type)) if eventName

  requestHandler: (callback) ->
    @xhr = new XMLHttpRequest() unless @xhr

    @xhr.addEventListener("load",
      ((event) =>
        callback(@xhr.responseXML, @setTrackers)
        @xhr.removeEventListener("load", arguments, false)
        @ready = true
      ),
      false
    )
    try
      @xhr.open("GET", @url)
      @xhr.send(null)
    catch e
      # do nothing and ignore errors
`export default VastRequest`
