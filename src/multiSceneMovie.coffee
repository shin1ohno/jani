#multi scene movie sample application

`import Movie from "multiSceneMovie/movie"`
`import Stage from "multiSceneMovie/stage"`
`import Scene from "multiSceneMovie/scene"`
`import EventEmitter from "multiSceneMovie/eventEmitter"`

class MultiSceneMovie
  constructor: (@rootElement, @appearanceDetectorMarginTop=0, @appearanceDetectorMarginBottom=0) ->
    @createAndComposeScenes()

  startScenes: ->
    @scenes[0].start()
    @triggerEvent("movie:play")

  bindEvent: (eventName, callback) -> @getEventEmitter().listen(eventName, callback)

  triggerEvent: (eventName) -> @getEventEmitter().emit(eventName)

  getEventEmitter: -> new EventEmitter(@rootElement) #get singleton instance

  playMovieAtIndex: (index) ->
    return unless @movie
    @movie.moveToFrameIndex(index)
    @triggerEvent("movie:play")

  composeScenes = (rootElement, movie, movieScene, movieLoadScene, movieFinishScene, contentScene) ->
    ee = new EventEmitter(rootElement)

    movieStage = movieScene.stage
    movieStage.movie = movie # just for spec

    movie.movieDidLoad = -> ee.emit("movie:loaded")
    movie.movieDidStart = -> ee.emit("movie:started")
    movie.movieDidPause = -> ee.emit("movie:paused", { "index": movie.currentFrameIndex })
    movie.movieDidResume = -> ee.emit("movie:resumed")
    movie.movieDidFinish = -> ee.emit("movie:finished")
    movie.movieDidPlayedTo = (seconds) -> ee.emit("movie:played:#{seconds}")
    movieStage.appearanceDetector.didAppear = -> ee.emit("movie:screen:appeared")
    movieStage.appearanceDetector.didDisappear = -> ee.emit("movie:screen:disappeared")

    ee.listen("movie:loaded", movieLoadScene.finish)
    ee.listen("movie:finished", movieScene.finish)
    ee.listen("movie:finished", movieFinishScene.start)
    ee.listen("movie:screen:appeared", -> movie.play() if movieStage.isOpen())
    ee.listen("movie:screen:disappeared", -> movie.pause())
    ee.listen("movie:play", -> movie.play() if movieStage.isOpen())
    ee.listen("movie:pause", -> movie.pause())
    ee.listen("movie:resume", -> movie.play() if movieStage.isOpen())

    movieLoadScene.sceneDidStart = movie.loadMovie
    movieLoadScene.sceneDidFinish = movieScene.start

    movieScene.sceneDidStart = ->
      movie.rewind()
      movie.play() if movieStage.detectAppearance().bind?(movieStage)

    movieScene.sceneDidFinish = contentScene.start

    document.addEventListener("scroll", movieStage.detectAppearance.bind?(movieStage), false)
    # Function.prototype.bind is not supported by phantomjs but no scroll in phantomjs so just ignore

    movieFinishScene.stage.element.addEventListener("click", ->
      ee.emit("movie:replay")
    ,false)

    ee.listen("movie:replay", ->
      contentScene.stage.close()
      movieFinishScene.finish()
      movieScene.start()
      ee.emit("movie:replayed")
    )

  createAndComposeScenes: ->
    @rootElement = convertToPureHTMLDOMElement(@rootElement)
    return unless @rootElement

    new EventEmitter(@rootElement) # Create singleton instance

    stagesDataset = @rootElement.dataset
    return unless stagesDataset

    movieLoadElement = @rootElement.getElementsByClassName(stagesDataset["loadingStage"])[0]
    movieFinishElement = @rootElement.getElementsByClassName(stagesDataset["finishedStage"])[0]
    contentElement = @rootElement.getElementsByClassName(stagesDataset["contentStage"])[0]

    movieDataset = @rootElement.getElementsByClassName(stagesDataset["movieStage"])[0].dataset
    screenElement = @rootElement.getElementsByClassName(movieDataset["screen"])[0]
    stripElements = @rootElement.getElementsByClassName(movieDataset["stripsContainer"])[0].getElementsByClassName(movieDataset["strips"])

    return unless screenElement

    movie = Movie.createFromHTMLElement(screenElement, stripElements)
    @movie = movie

    createScene = (sceneElement) => new Scene(new Stage(sceneElement, @appearanceDetectorMarginTop, @appearanceDetectorMarginBottom))
    movieScene = createScene(screenElement)
    movieLoadScene = createScene(movieLoadElement)
    movieFinishScene = createScene(movieFinishElement)
    contentScene = createScene(contentElement)

    composeScenes(@rootElement, movie, movieScene, movieLoadScene, movieFinishScene, contentScene)
    @scenes = [movieLoadScene, movieScene, movieFinishScene, contentScene]

  convertToPureHTMLDOMElement = (element) ->
    return undefined unless element
    result = undefined
    if typeof(element) == "string" # old api
      result = document.getElementById(element)
    else
      if element.selector # jquery or zepto object
        result = element[0]
      else # pure HTML DOM element
        result = element
    return result

`export default MultiSceneMovie`
