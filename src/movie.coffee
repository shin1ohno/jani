`import Screen from "multiSceneMovie/screen"`
`import Strip from "multiSceneMovie/strip"`

class Movie
  constructor: (@screen, @strips, @fps) ->
    @screen.setStrips(@strips)
    @_loaded = 0
    @currentFrameIndex = 0
    @currentTimeCodeInSeconds = 0
    @currentTimeCodeInSecondsWas = 0
    @framesCount = @strips.reduce(
      (result, strip) ->
        result + strip.framesCount
      , 0
    )
    @strips.forEach (strip) =>
      strip.stripImageDidLoad = =>
        @_loaded += 1
        @movieDidLoad() if @_loaded == Math.ceil(@strips.length/3)

  loadMovie: =>
    @strips.forEach (strip) ->
      strip.loadStripImage()

  moveFrameIndex: ->
    @currentFrameIndex++
    @currentTimeCodeInSecondsWas = @currentTimeCodeInSeconds
    @currentTimeCodeInSeconds = Math.floor(@currentFrameIndex / @fps)
    if @currentFrameIndex == Math.floor(@framesCount / 4)
      @firstQuartile()
    if @currentFrameIndex == Math.floor(@framesCount / 2)
      @half()
    if @currentFrameIndex == Math.floor(@framesCount / 4 * 3)
      @thirdQuartile()

    if @currentTimeCodeInSecondsWas != @currentTimeCodeInSeconds
      @movieDidPlayedTo(@currentTimeCodeInSeconds)

  play: ->
    return if @timerId #already played
    if @isAtFirstFrame()
      @movieDidStart()
    else
      @movieDidResume()
    @timerId = setInterval(=>
      if @isAtLastFrame()
        @pause()
        @screen.currentStrip().deactivate()
        @screen.currentStripIndex = 0
        @screen.currentStrip().activate()
        @movieDidFinish()
      @screen.showCurrentFrame()
      @screen.moveFrameToNext()
      @moveFrameIndex()
    , 1000/@fps)

  pause: ->
    @movieDidPause() unless @isAtLastFrame()
    clearInterval(@timerId) if @timerId
    @timerId = undefined

  rewind: ->
    @screen.moveFrameToFirst()
    @currentFrameIndex = 0
    @currentTimeCodeInSeconds = 0
    @currentTimeCodeInSecondsWas = 0

  moveToFrameIndex: (frameIndex) ->
    @pause()
    @screen.currentStrip().resetFrame()
    @screen.currentStrip().deactivate()
    fi = frameIndex
    si = 0
    while(fi > @strips[si].framesCount)
      fi -= @strips[si].framesCount
      si++

    @screen.currentStripIndex = si
    @screen.currentStrip().resetFrame()
    @screen.currentStrip().frameIndex = fi
    @screen.currentStrip().activate()
    @screen.showCurrentFrame()
    @currentFrameIndex = frameIndex

  isAtFirstFrame: -> @screen.isAtFirstFrame()

  isAtLastFrame: -> @screen.isAtLastFrame()

  movieDidLoad: ->
  movieDidStart: ->
  movieDidResume: ->
  movieDidPause: ->
  movieDidFinish: ->
  movieDidPlayedTo: (seconds) ->
  firstQuartile: ->
  half: ->
  thirdQuartile: ->

  @createFromHTMLElement: (screenElement, stripElements) ->
    movieData = screenElement.dataset

    width = parseInt(movieData.frameWidth, 10)
    height = parseInt(movieData.frameHeight, 10)

    screen = new Screen(screenElement)
    screenElement.style.width = "#{width}px"
    screenElement.style.height = "#{height}px"

    strips = []
    strips.push(new Strip(strip.dataset.url, width, height, parseInt(strip.dataset.framesCount, 10), strip)) for strip in stripElements

    movie = new Movie(screen, strips, parseInt(movieData.fps, 10))
    movie.frameWidth = width
    movie.frameHeight = height
    return movie

`export default Movie`
