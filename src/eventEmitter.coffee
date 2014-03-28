class EventEmitter
  constructor: (element) ->
    return EventEmitter.instance if typeof(EventEmitter.instance) == "object"
    throw "please set root element for event emitting" unless element
    @element = element
    EventEmitter.instance = @

  emit: (type, obj) ->
    if typeof(obj) == "object"
      @element.dispatchEvent(new CustomEvent(type, obj))
    else
      @element.dispatchEvent(new Event(type))

  listen: (type, callback) ->
    @element.addEventListener(type, callback, false)

`export default EventEmitter`
