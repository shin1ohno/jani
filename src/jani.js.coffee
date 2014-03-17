class Strip
  constructor: (@image_uri, @frameWidth, @frameHeight, @framesCount) ->
    @frames = []
    @frames.push(new FrameRectangle(0, @frameHeight * (@framesCount - frameIndex))) for frameIndex in [0..(@framesCount - 1)]
    @frameIndex = 0

  currentFrame: ->
    @frames[@frameIndex]

  moveFrameToNext: ->
    if @isLastFrame()
      @frameIndex = 0
    else
      @frameIndex++

  isLastFrame: ->
    @frameIndex == @framesCount- 1

  toCssText: ->
    stripStyle = "background-image: url(#{@image_uri}); background-size: cover;　background-repeat: no-repeat;"
    stripStyle + @currentFrame().toCssText()

class FrameRectangle
  constructor: (@leftPosition, @topPosition) ->
  toCssText: ->
    "background-position: #{@leftPosition}px #{@topPosition}px;"

class Screen
  constructor: (@element) ->
  setStrips: (@strips) ->

  showCurrentFrame: ->
    defaultStyle = @element.style.cssText
    @element.style.cssText = defaultStyle + @currentStrip().toCssText()
  currentStrip: -> @strips[0] #TODO: implement multi strip

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

  movieDidLoad: =>

  play: ->
    return if @timerId #already played
    @timerId = setInterval(=>
      if @screen.currentStrip().isLastFrame() #TODO: implement multi strip
        @pause()
        @movieDidFinish()
      @screen.showCurrentFrame()
      @screen.currentStrip().moveFrameToNext()
    , 1000/@fps)

  pause: ->
    clearInterval(@timerId) if @timerId
    @timerId = undefined

  rewind: ->
    #TODO: implement multi strip
    @screen.currentStrip().frameIndex = 0

  movieDidFinish: ->

  @createFromHTMLElement: (screenElement, stripElements) ->
    movieData = screenElement.dataset
    screen = new Screen(screenElement)
    strips = []
    strips.push(new Strip(strip.dataset.url, parseInt(movieData.frameWidth, 10), parseInt(movieData.frameHeight, 10), parseInt(movieData.framesCount, 10))) for strip in stripElements
    new Movie(screen, strips, parseInt(movieData.fps, 10))

class Stage
  constructor: (@element) ->

  stageDidAppear: ->

  stageDidDisapper: ->

  open: -> @element.classList.remove('hide')
  close: -> @element.classList.add('hide')

class MovieStage extends Stage
  constructor: (@movie) ->
    @element = @movie.screen.element
    @ad = new AppearanceDetector(@element)
    @ad.didAppear = @stageDidAppear
    @ad.didDisappear = @stageDidDisappear
    @movie.play() if @ad.visible()

  stageDidAppear: =>
    @movie.play()

  stageDidDisappear: =>
    @movie.pause()

  detectAppearance: =>
    @ad.detect()

class AppearanceDetector
  constructor: (@element) ->
    @wasVisible = false
    @detect()

  viewportHeight: -> window.innerHeight
  viewportTop: -> window.scrollY
  viewportBottom: -> @viewportTop() + @viewportHeight()
  elementTop: -> @element.offsetTop
  elementBottom: -> @elementTop() + @element.offsetHeight

  topVisible: ->
    @elementTop() > @viewportTop() && @elementTop() < @viewportBottom()

  bottomVisible: ->
    @elementBottom() > @viewportTop() && @elementBottom() < @viewportBottom()

  visible: ->
    @topVisible() && @bottomVisible()

  didAppear: ->

  didDisappear: ->

  detect: ->
    toVisible = @visible()

    if toVisible
      @didAppear() unless @wasVisible
    else
      @didDisappear() if @wasVisible

    @wasVisible = toVisible

class Scene
  constructor: (@stage) ->

  sceneDidStart: ->
  sceneDidFinish: ->

  start: =>
    @stage.open()
    @sceneDidStart()

  finish: =>
    @stage.close()
    @sceneDidFinish()

# sample
# $( ()->
#   screenElement = document.getElementById('movie')
#   stripElements = document.getElementById('movie_strips').getElementsByClassName('strip')
#   movie = Movie.createFromHTMLElement(screenElement, stripElements)

#   moviePlayStage = new MovieStage(movie)
#   movieScene = new Scene(moviePlayStage)
#   movieScene.finish()

#   movieLoadStage = new Stage($("#sp_window .movie_control.loading")[0])
#   movieLoadScene = new Scene(movieLoadStage)
#   movieLoadScene.sceneDidStart = movie.loadMovie
#   movieLoadScene.start()

#   movieFinishStage = new Stage($("#sp_window .movie_control.finished")[0])
#   movieFinishScene = new Scene(movieFinishStage)
#   movieFinishScene.finish()

#   movie.movieDidLoad = ->
#     movieLoadScene.finish()
#     movieScene.start()

#   movie.movieDidFinish = ->
#     movieScene.finish()
#     movieFinishScene.start()

#   contentStage = new Stage(document.getElementById('contents'))
#   contentScene = new Scene(contentStage)
#   movieScene.sceneDidFinish = contentScene.start

#   movieScene.sceneDidStart = ->
#     movie.rewind()
#     movie.play() if @stage.detectAppearance()

#   $(document).bind('scroll', moviePlayStage.detectAppearance)
#   $('#contents .button_region').bind('click', contentScene.finish)
#   $('.movie_control.finished').bind('click',->
#     movieFinishScene.finish()
#     movieScene.start()
#   )
# )
