`import EventEmitter from "multiSceneMovie/eventEmitter"`

describe "event emitting and listening", ->
  it "throws error without element", ->
    expect(-> new EventEmitter()).toThrow("please set root element for event emitting")

  it "is Singleton", ->
    element = document.createElement("div")
    ee1 = new EventEmitter(element)
    ee2 = new EventEmitter(element)
    ee3 = new EventEmitter()
    expect(ee2).toBe(ee1)
    expect(ee3).toBe(ee1)

  it "emits event", ->
    element = document.createElement("div")
    ee = new EventEmitter(element)
    spy = jasmine.createSpy("eventCallback")
    callback = (e) -> spy()
    ee.listen("movie:paused", callback)
    ee.emit("movie:paused")
    expect(spy).toHaveBeenCalled()

  it "emits custom event", ->
    element = document.createElement("div")
    ee = new EventEmitter(element)
    spy = jasmine.createSpy("eventCallback")
    callback = (e) -> spy(e.detail)
    ee.listen("movie:paused", callback)
    obj = { movie: "movie" }
    ee.emit("movie:paused", {detail: obj})
    expect(spy).toHaveBeenCalledWith(obj)
