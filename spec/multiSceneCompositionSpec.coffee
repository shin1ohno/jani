describe "end to end: multi scene composition", ->
  beforeEach ->
    jasmine.getFixtures().fixturesPath = "fixtures"
    loadFixtures("movie.html")
    @composed = (require "multiSceneMovie/app")["default"]("stages_container")
    @loading = @composed[0]
    @playing = @composed[1]
    @finished = @composed[2]
    @content = @composed[3]
    jasmine.clock().install()
    spyOn(@playing.stage, "detectAppearance").and.returnValue(false)
    @loading.start()
    @isHidden = (scene) -> scene.stage.element.classList.contains("hide")

  afterEach ->
    jasmine.clock().uninstall()

  it "returns scenes", ->
    expect(@composed.constructor.name).toBe("Array")
    expect(scene.constructor.name).toBe("Scene") for scene in @composed

  it "is loading movie at start", ->
    expect(@isHidden(@loading)).toBe(false)
    expect(@isHidden(@playing)).toBe(true)
    expect(@isHidden(@finished)).toBe(true)
    expect(@isHidden(@content)).toBe(true)

  describe "after movie strips loaded", ->
    beforeEach ->
      @playing.stage.movie.movieDidLoad()

    it "is ready to play movie", ->
      expect(@isHidden(@loading)).toBe(true)
      expect(@isHidden(@playing)).toBe(false)
      expect(@isHidden(@finished)).toBe(true)
      expect(@isHidden(@content)).toBe(true)

    it "keeps pausing movie before movie stage appears", ->
      expect(@playing.stage.movie.screen.currentStrip().frameIndex).toBe(0)
      jasmine.clock().tick(10000)
      expect(@playing.stage.movie.screen.currentStrip().frameIndex).toBe(0)

    it "plays movie to last after movie stage appears", ->
      @playing.stage.stageDidAppear()
      jasmine.clock().tick(10000)
      expect(@playing.stage.movie.screen.currentStrip().isLastFrame()).toBe(true)

  describe "when finished playing movie", ->
    beforeEach ->
      @playing.stage.movie.movieDidLoad()
      @playing.stage.stageDidAppear()
      jasmine.clock().tick(40000) #wired. 10000 should be enough

    it "shows replay UI and content", ->
      expect(@isHidden(@loading)).toBe(true)
      expect(@isHidden(@playing)).toBe(true)
      expect(@isHidden(@finished)).toBe(false)
      expect(@isHidden(@content)).toBe(false)

    describe "when replay UI clicked", ->
      beforeEach ->
        $('.movie_control.finished').click()
        @playing.stage.movie.movieDidLoad()
        @playing.stage.stageDidAppear()

      it "rewind and replay movie", ->
        expect(@isHidden(@loading)).toBe(true)
        expect(@isHidden(@playing)).toBe(false)
        expect(@isHidden(@finished)).toBe(true)
        expect(@isHidden(@content)).toBe(false)
