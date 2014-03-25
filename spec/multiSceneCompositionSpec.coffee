describe "end to end: multi scene composition", ->
  beforeEach ->
    jasmine.getFixtures().fixturesPath = "fixtures"
    loadFixtures("movie.html")
    @composed = (require "multiSceneMovie/app")["default"]
    @loading = @composed[0]
    @playing = @composed[1]
    @finished = @composed[2]
    @content = @composed[3]
    jasmine.clock().install()
    @classList = (scene) -> scene.stage.element.classList

  afterEach ->
    jasmine.clock().uninstall()

  it "returns scenes", ->
    expect(@composed.constructor.name).toBe("Array")
    expect(scene.constructor.name).toBe("Scene") for scene in @composed

  it "is loading movie at start", ->
    expect(@classList(@loading).contains("hide")).toBe(false)
    expect(@classList(@playing).contains("hide")).toBe(true)
    expect(@classList(@finished).contains("hide")).toBe(true)
    expect(@classList(@content).contains("hide")).toBe(true)

  describe "after movie strips loaded", ->
    beforeEach ->
      @playing.stage.movie.movieDidLoad()

    it "is ready to play movie", ->
      expect(@classList(@loading).contains("hide")).toBe(true)
      expect(@classList(@playing).contains("hide")).toBe(false)
      expect(@classList(@finished).contains("hide")).toBe(true)
      expect(@classList(@content).contains("hide")).toBe(true)

    it "keeps pausing movie before movie stage appears", ->
      expect(@playing.stage.movie.screen.currentStrip().frameIndex).toBe(0)
      jasmine.clock().tick(40000)
      expect(@playing.stage.movie.screen.currentStrip().frameIndex).toBe(0)

    it "plays movie to last after movie stage appears", ->
      @playing.stage.stageDidAppear()
      jasmine.clock().tick(40000)
      expect(@playing.stage.movie.screen.currentStrip().isLastFrame()).toBe(true)

  describe "when finished playing movie", ->
    beforeEach ->
      @playing.stage.movie.movieDidLoad()
      @playing.stage.stageDidAppear()
      jasmine.clock().tick(40000)

    it "shows replay UI and content", ->
      expect(@classList(@loading).contains("hide")).toBe(true)
      expect(@classList(@playing).contains("hide")).toBe(true)
      expect(@classList(@finished).contains("hide")).toBe(false)
      expect(@classList(@content).contains("hide")).toBe(false)
