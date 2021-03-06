`import Movie from "multiSceneMovie/movie"`

describe "single strip movie", ->
  beforeEach ->
    jasmine.getFixtures().fixturesPath = "fixtures"
    loadFixtures("movie.html")

  describe "createFromHTMLElement", ->
    beforeEach ->
      @movie = Movie.createFromHTMLElement($(".movie")[0], $(".movie_strips .strip"))
      jasmine.clock().install()

    afterEach ->
      jasmine.clock().uninstall()

    it "creates movie", ->
      expect(@movie.fps).toEqual(30)
      expect(@movie.strips.length).toEqual(1)

    it "plays to last frame", ->
      @movie.play()
      jasmine.clock().tick(10000);
      expect(@movie.isAtLastFrame()).toBe(true)

    it "pause and plays to last frame", ->
      @movie.play()
      jasmine.clock().tick(5000);
      @movie.pause()
      @movie.play()
      jasmine.clock().tick(5000);
      expect(@movie.isAtLastFrame()).toBe(true)

    it "kicks movieDidPlayedTo every seconds while playing", ->
      spyOn(@movie, "movieDidPlayedTo")

      @movie.play()
      jasmine.clock().tick(1001)

      @movie.pause()
      jasmine.clock().tick(1001)

      expect(@movie.movieDidPlayedTo).toHaveBeenCalledWith(1)
      expect(@movie.movieDidPlayedTo.calls.count()).toEqual(1)

      @movie.play()
      jasmine.clock().tick(14001)
      expect(@movie.movieDidPlayedTo.calls.count()).toEqual(15)

    it "set frames count to movie", ->
      expect(@movie.framesCount).toEqual(300)
