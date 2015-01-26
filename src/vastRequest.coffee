class VastRequest
  constructor: (@url, @eventEmitter, @callback) ->
    @clickThrough = undefined
    @run() if @url

  valid: ->
    return false unless @url
    return true

  run: -> @requestHandler(@setTrackers)

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
          event: "start",
          url: node.textContent,
          type: "img"
        })
    )
    @callback(@eventEmitter, tracking) for tracking in trackings

  requestHandler: (callback) ->
    @xhr = new XMLHttpRequest() unless @xhr

    @xhr.addEventListener("load",
      ((event) =>
        callback(@xhr.responseXML)
        @xhr.removeEventListener("load", arguments, false)
      ),
      false
    )
    try
      @xhr.open("GET", @url)
      @xhr.send(null)
    catch e
      # do nothing and ignore errors
`export default VastRequest`
