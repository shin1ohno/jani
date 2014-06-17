`import EventEmitter from "multiSceneMovie/eventEmitter"`

describe "event emitting and listening", ->
  it "throws error without element", ->
    expect(-> new EventEmitter()).toThrow("please set root element for event emitting")

  it "is Singleton for root container element", ->
    element = document.createElement("div")
    anotherElement = document.createElement("div")
    expect(element).not.toBe(anotherElement)

    ee1 = new EventEmitter(element)
    ee2 = new EventEmitter(element)
    ee3 = new EventEmitter(anotherElement)
    ee4 = new EventEmitter(anotherElement)

    expect(ee2).toBe(ee1)
    expect(ee3).not.toBe(ee1)
    expect(ee4).toBe(ee3)

    expect(-> new EventEmitter()).toThrow("please set root element for event emitting")

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
