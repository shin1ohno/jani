class EventEmitter
  constructor: (element) ->
    EventEmitter.instances = [] unless EventEmitter.instances
    throw "please set root element for event emitting" unless element

    singleton = EventEmitter.instances.filter((instance) -> instance.element == element)[0]
    return singleton if singleton

    @element = element
    EventEmitter.instances.push(this)

  emit: (type, obj) ->
    if typeof(obj) == "object"
      if typeof(CustomEvent) == "object"
        @element.dispatchEvent(new CustomEvent(type, {"detail": obj}))
      else
        #Some old browser and phantomjs don't implement CustomEvent
        newEvent = document.createEvent('CustomEvent')
        newEvent.initCustomEvent(type, false, false, obj)
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
