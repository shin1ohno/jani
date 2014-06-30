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
    beforeEach -> @app.triggerEvent("movie:loaded")

    it "thows no error", ->
      for eventName in ["movie:screen:disappeared"]
        @app.triggerEvent(eventName)

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
      @app.triggerEvent("movie:screen:appeared")
      expect(@movie.isAtFirstFrame()).toBe(true)
      jasmine.clock().tick(10000)
      expect(@movie.isAtLastFrame()).toBe(true)

    it "pauses movie when movie stage disappears", ->
      @app.triggerEvent("movie:screen:appeared")
      expect(@movie.isAtFirstFrame()).toBe(true)
      jasmine.clock().tick(5000)
      @app.triggerEvent("movie:screen:disappeared")
      jasmine.clock().tick(5000)
      expect(@movie.isAtLastFrame()).toBe(false)

  describe "when finished playing movie", ->
    beforeEach ->
      @app.triggerEvent("movie:loaded")
      @app.triggerEvent("movie:screen:appeared")
      jasmine.clock().tick(10001)

    it "shows replay UI and content", ->
      expect(@isHidden(@loading)).toBe(true)
      expect(@isHidden(@playing)).toBe(true)
      expect(@isHidden(@finished)).toBe(false)
      expect(@isHidden(@content)).toBe(false)

    describe "when replay UI clicked", ->
      beforeEach -> @app.triggerEvent("movie:replay")

      it "rewind and replay movie", ->
        expect(@isHidden(@loading)).toBe(true)
        expect(@isHidden(@playing)).toBe(false)
        expect(@isHidden(@finished)).toBe(true)
        expect(@isHidden(@content)).toBe(true)

  describe "event emittions", ->
    describe "event binding with callbacks", ->
      beforeEach ->
        @spy = jasmine.createSpy("eventSpy")
        @app.bindEvent("movie:finished", => @spy("movie:finished"))
        @app.bindEvent("movie:resumed", => @spy("movie:resumed"))
        @app.bindEvent("movie:paused", => @spy("movie:paused"))
        @app.bindEvent("movie:started", => @spy("movie:started"))
        @app.bindEvent("movie:played:5", => @spy("movie:played:5"))
        @app.bindEvent("movie:played:10", => @spy("movie:played:10"))

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

  describe "Movie", ->
    it "moves frame to given index", ->
      n = Math.floor(Math.random() * 100)
      @movie.moveToFrameIndex(n)
      expect(@movie.currentFrameIndex).toEqual(n)

    describe "callback", ->
      beforeEach ->
        @indexSpy = jasmine.createSpy("indexSpy")
        @app.bindEvent("movie:paused", (data) => @indexSpy(data.detail.index))
        @app.triggerEvent("movie:loaded")
        @app.triggerEvent("movie:screen:appeared")

      it "passes Event object to callback", ->
        @app.triggerEvent("movie:play")
        jasmine.clock().tick(1001) # 1 sec. +
        @app.triggerEvent("movie:pause")
        expect(@indexSpy).toHaveBeenCalledWith(30) # 1 sec. @30fps
