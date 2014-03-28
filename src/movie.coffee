`import Screen from "multiSceneMovie/screen"`
`import Strip from "multiSceneMovie/strip"`

class Movie
  constructor: (@screen, @strips, @fps) ->
    @screen.setStrips(@strips)
    @_loaded = 0

  loadMovie: =>
    for strip in @strips
      image = new Image()
      image.onload = =>
        @_loaded += 1
        @movieDidLoad() if @_loaded == @strips.length

      image.src = strip.image_uri

  movieDidLoad: ->

  play: ->
    return if @timerId #already played
    if @isAtFirstFrame()
      @movieDidStart()
    else
      @movieDidResume()
    @timerId = setInterval(=>
      if @isAtLastFrame()
        @pause()
        @movieDidFinish()
      @screen.showCurrentFrame()
      @screen.moveFrameToNext()
    , 1000/@fps)

  pause: ->
    @movieDidPause() unless @isAtLastFrame()
    clearInterval(@timerId) if @timerId
    @timerId = undefined

  rewind: -> @screen.moveFrameToFirst()

  isAtFirstFrame: -> @screen.isAtFirstFrame()

  isAtLastFrame: -> @screen.isAtLastFrame()

  movieDidStart: ->
  movieDidResume: ->
  movieDidPause: ->
  movieDidFinish: ->

  @createFromHTMLElement: (screenElement, stripElements) ->
    movieData = screenElement.dataset
    screen = new Screen(screenElement)
    strips = []
    strips.push(new Strip(strip.dataset.url, parseInt(movieData.frameWidth, 10), parseInt(movieData.frameHeight, 10), parseInt(strip.dataset.framesCount, 10))) for strip in stripElements
    new Movie(screen, strips, parseInt(movieData.fps, 10))

`export default Movie`

