class RequestBuffer
  constructor: () ->
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
    @xhr = (if window.XDomainRequest then new XDomainRequest() else new XMLHttpRequest())  unless @xhr
    @xhr.addEventListener("load",
      ((event) =>
        @queue.shift()
        callback()
        @xhr.removeEventListener("load", arguments, false)
      ),
      false
    )
    try
      @xhr.open("GET", @queue[0])
      @xhr.send(null)
    catch e
      # do nothing and ignore errors

`export default RequestBuffer`
