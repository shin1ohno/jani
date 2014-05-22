class EventEmitter
  constructor: (element) ->
    return EventEmitter.instance if typeof(EventEmitter.instance) == "object"
    throw "please set root element for event emitting" unless element
    @element = element
    EventEmitter.instance = @

  emit: (type, obj) ->
    if typeof(obj) == "object"
      if typeof(CustomEvent) == "function"
        @element.dispatchEvent(new CustomEvent(type, obj))
      else
        #Some old browser and phantomjs don't implement CustomEvent
        newEvent = document.createEvent('CustomEvent')
        newEvent.initCustomEvent(type, false, false, obj.detail)
        @element.dispatchEvent(newEvent)
    else
      try
        @element.dispatchEvent(new Event(type))
      catch e
        #Android browser and phantomjs can't handle new Event(type) right
        newEvent = document.createEvent("CustomEvent")
        newEvent.initEvent(type, false, false)
        @element.dispatchEvent(newEvent)

  listen: (type, callback) ->
    @element.addEventListener(type, callback, false)

`export default EventEmitter`
