`import Screen from "multiSceneMovie/screen"`
`import Strip from "multiSceneMovie/strip"`

class Movie
  constructor: (@screen, @strips, @fps) ->
    @screen.setStrips(@strips)
    @_loaded = 0
    @currentFrameIndex = 0
    @currentTimeCodeInSeconds = 0
    @currentTimeCodeInSecondsWas = 0
    @strips.forEach (strip) =>
      strip.stripImageDidLoad = =>
        @_loaded += 1
        @movieDidLoad() if @_loaded == @strips.length

  loadMovie: =>
    @strips.forEach (strip) ->
      strip.loadStripImage()

  moveFrameIndex: ->
    @currentFrameIndex++
    @currentTimeCodeInSecondsWas = @currentTimeCodeInSeconds
    @currentTimeCodeInSeconds = Math.floor(@currentFrameIndex / @fps)
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
        @screen.currentStipIndex = 0
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

  isAtFirstFrame: -> @screen.isAtFirstFrame()

  isAtLastFrame: -> @screen.isAtLastFrame()

  movieDidLoad: ->
  movieDidStart: ->
  movieDidResume: ->
  movieDidPause: ->
  movieDidFinish: ->
  movieDidPlayedTo: (seconds) ->

  @createFromHTMLElement: (screenElement, stripElements) ->
    movieData = screenElement.dataset

    width = parseInt(movieData.frameWidth, 10)
    height = parseInt(movieData.frameHeight, 10)

    screen = new Screen(screenElement)
    screen.element.style.width = width
    screen.element.style.height = height

    strips = []
    strips.push(new Strip(strip.dataset.url, width, height, parseInt(strip.dataset.framesCount, 10), strip)) for strip in stripElements

    new Movie(screen, strips, parseInt(movieData.fps, 10))

`export default Movie`

