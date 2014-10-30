class RequestBuffer
  constructor: (@type = "img") ->
    @queue = []
    @xhr = null

  push: (url) ->
    @queue.push(url)
    @run() if @queue.length is 1

  run: () ->
    callback = () =>
      @run() if @queue.length > 0
    @requestHandler(callback)

  requestHandler: (callback) ->
    switch @type
      when "img"
        url = @queue[0]
        beacon = document.createElement("img")
        beacon.width = 0
        beacon.height = 0
        beacon.style.display = "none"
        beacon.src = url
        document.getElementsByTagName("body")[0].appendChild(beacon)
        beacon.addEventListener("load",
          ((event) =>
            @queue.shift()
            callback()
            beacon.removeEventListener("load", arguments, false)
          ),
          false
        )
      when "xhr"
        @xhr = (if window.XDomainRequest then new XDomainRequest() else new XMLHttpRequest()) unless @xhr
        @xhr.addEventListener("load",
          ((event) =>
            @queue.shift()
            callback()
            @xhr.removeEventListener("load", arguments, false)
          ),
          false
        )
        try
          url = @queue[0]
          @xhr.open("GET", url)
          @xhr.send(null)
        catch e
          # do nothing and ignore errors

`export default RequestBuffer`
