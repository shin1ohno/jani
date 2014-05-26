`import EventEmitter from "multiSceneMovie/eventEmitter"`
`import MultiSceneMovie from "multiSceneMovie/multiSceneMovie"`

describe "end to end: multi scene composition", ->
  beforeEach ->
    jasmine.getFixtures().fixturesPath = "fixtures"
    loadFixtures("movie.html")
    #10 seconds movie @30fps loaded
    @app = new MultiSceneMovie("stages_container")
    @scenes = @app.scenes
    @loading = @scenes[0]
    @playing = @scenes[1]
    @finished = @scenes[2]
    @content = @scenes[3]
    @movie = @playing.stage.movie
    jasmine.clock().install()
    spyOn(@playing.stage, "detectAppearance").and.returnValue(false)
    @app.startScenes()
    @isHidden = (scene) -> scene.stage.element.classList.contains("hide")
    @ee = new EventEmitter()

  afterEach ->
    jasmine.clock().uninstall()

  it "creates scenes", ->
    expect(@scenes.constructor.name).toBe("Array")
    expect(scene.constructor.name).toBe("Scene") for scene in @scenes

  it "is loading movie at start", ->
    expect(@isHidden(@loading)).toBe(false)
    expect(@isHidden(@playing)).toBe(true)
    expect(@isHidden(@finished)).toBe(true)
    expect(@isHidden(@content)).toBe(true)

  describe "after movie strips loaded", ->
    beforeEach -> @ee.emit("movie:loaded")

    it "thows no error", ->
      for eventName in ["movie:screen:disappeared"]
        @ee.emit(eventName)

    it "is ready to play movie", ->
      expect(@isHidden(@loading)).toBe(true)
      expect(@isHidden(@playing)).toBe(false)
      expect(@isHidden(@finished)).toBe(true)
      expect(@isHidden(@content)).toBe(true)

    it "keeps pausing movie before movie stage appears", ->
      expect(@movie.isAtFirstFrame()).toBe(true)
      jasmine.clock().tick(10000)
      expect(@movie.isAtFirstFrame()).toBe(true)

    it "plays movie to last after movie stage appears", ->
      @ee.emit("movie:screen:appeared")
      expect(@movie.isAtFirstFrame()).toBe(true)
      jasmine.clock().tick(10000)
      expect(@movie.isAtLastFrame()).toBe(true)

    it "pauses movie when movie stage disappears", ->
      @ee.emit("movie:screen:appeared")
      expect(@movie.isAtFirstFrame()).toBe(true)
      jasmine.clock().tick(5000)
      @ee.emit("movie:screen:disappeared")
      jasmine.clock().tick(5000)
      expect(@movie.isAtLastFrame()).toBe(false)

  describe "when finished playing movie", ->
    beforeEach ->
      @ee.emit("movie:loaded")
      @ee.emit("movie:screen:appeared")
      jasmine.clock().tick(10001)

    it "shows replay UI and content", ->
      expect(@isHidden(@loading)).toBe(true)
      expect(@isHidden(@playing)).toBe(true)
      expect(@isHidden(@finished)).toBe(false)
      expect(@isHidden(@content)).toBe(false)

    describe "when replay UI clicked", ->
      beforeEach -> @ee.emit("movie:replay")

      it "rewind and replay movie", ->
        expect(@isHidden(@loading)).toBe(true)
        expect(@isHidden(@playing)).toBe(false)
        expect(@isHidden(@finished)).toBe(true)
        expect(@isHidden(@content)).toBe(true)

  describe "event emittions", ->
    describe "event binding with callbacks", ->
      beforeEach ->
        @spy = jasmine.createSpy("eventSpy")
        @ee.listen("movie:finished", => @spy("movie:finished"))
        @ee.listen("movie:resumed", => @spy("movie:resumed"))
        @ee.listen("movie:paused", => @spy("movie:paused"))
        @ee.listen("movie:started", => @spy("movie:started"))
        @ee.listen("movie:played:5", => @spy("movie:played:5"))
        @ee.listen("movie:played:10", => @spy("movie:played:10"))

        @appEventSpy = jasmine.createSpy("appEventSpy")
        @app.bindEvent("movie:played:10", @appEventSpy)

      it "emits", ->
        @movie.rewind()
        @movie.play()
        jasmine.clock().tick(5000)
        @movie.pause()
        @movie.play()
        jasmine.clock().tick(5001)
        expect(@appEventSpy).toHaveBeenCalled()
        @movie.rewind()
        @movie.play()
        jasmine.clock().tick(5000)
        expect(@spy.calls.allArgs().map((args) -> args[0])).toEqual(
            [
              'movie:started',
              'movie:played:5',
              'movie:paused',
              'movie:resumed',
              'movie:finished',
              'movie:played:10',
              'movie:started',
              'movie:played:5',
            ]
          )

    describe "event triggering", ->
      beforeEach ->
        @appTriggerSpy = jasmine.createSpy("appTriggerSpy")

      it "emits", ->
        @app.bindEvent("movie:pause", @appTriggerSpy)
        @app.triggerEvent("movie:pause")
        expect(@appTriggerSpy).toHaveBeenCalled()
