describe "Movie", ->
  beforeEach ->
    jasmine.getFixtures().fixturesPath = "spec/fixtures"
    loadFixtures("movie.html")

  describe "createFromHTMLElement", ->
    beforeEach ->
      @movie = Movie.createFromHTMLElement($("#movie")[0], $("#movie_strips .strip"))
      jasmine.Clock.useMock();

    it "creates movie", ->
      expect(@movie.fps).toEqual(30)
      expect(@movie.strips.length).toEqual(1)

    it "plays to last frame", ->
      @movie.play()
      jasmine.Clock.tick(10000);
      expect(@movie.screen.currentStrip().isLastFrame()).toBe(true)

    it "pause and plays to last frame", ->
      @movie.play()
      jasmine.Clock.tick(5000);
      @movie.pause()
      @movie.play()
      jasmine.Clock.tick(5000);
      expect(@movie.screen.currentStrip().isLastFrame()).toBe(true)
