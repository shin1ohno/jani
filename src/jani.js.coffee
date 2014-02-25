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

  play: ->
    @timerId = setInterval(=>
      @screen.showCurrentFrame()
      @screen.currentStrip().moveFrameToNext()
    , 1000/@fps)

  pause: ->
    clearInterval(@timerId) if @timerId

# sample

screenElement = document.getElementById('movie')
movieData = screenElement.dataset
screen = new Screen(screenElement)
strips = [].concat(new Strip(img.src, movieData.frameWidth, movieData.frameHeight, movieData.framesCount)) for img in document.getElementById('strips').getElementsByTagName('img')
movie = new Movie(screen, strips, movieData.fps)
window.movie = movie
movie.play()
setTimeout(->
  movie.pause()
,15000)
