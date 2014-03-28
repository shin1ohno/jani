#multi scene movie sample application

`import Movie from "multiSceneMovie/movie"`
`import Stage from "multiSceneMovie/stage"`
`import Scene from "multiSceneMovie/scene"`
`import EventEmitter from "multiSceneMovie/eventEmitter"`

class MultiSceneMovie
  constructor: (@rootElementId) ->
    @createAndComposeScenes()

  startScenes: ->
    @scenes[0].start()

  composeScenes = (movie, movieScene, movieLoadScene, movieFinishScene, contentScene) ->
    ee = new EventEmitter()

    movieStage = movieScene.stage
    movieStage.movie = movie # just for spec

    movie.movieDidLoad = -> ee.emit("movie:loaded")
    movie.movieDidStart = -> ee.emit("movie:started")
    movie.movieDidPause = -> ee.emit("movie:paused")
    movie.movieDidResume = -> ee.emit("movie:resumed")
    movie.movieDidFinish = -> ee.emit("movie:finished")
    movieStage.stageDidAppear = -> ee.emit("movie:screen:appeared")
    movieStage.stageDidDisappear = -> ee.emit("movie:screen:disappeared")

    ee.listen("movie:loaded", movieLoadScene.finish)
    ee.listen("movie:finished", movieScene.finish)
    ee.listen("movie:finished", movieFinishScene.start)
    ee.listen("movie:screen:appeared", -> movie.play() if movieStage.isOpen())
    ee.listen("movie:screen:disappeared", -> movie.pause())

    movieLoadScene.sceneDidStart = movie.loadMovie
    movieLoadScene.sceneDidFinish = movieScene.start

    movieScene.sceneDidStart = ->
      movie.rewind()
      movie.play() if movieStage.detectAppearance()

    movieScene.sceneDidFinish = contentScene.start

    document.addEventListener("scroll", movieStage.detectAppearance, false)
    movieFinishScene.stage.element.addEventListener("click", ->
      movieFinishScene.finish()
      movieScene.start()
    , false)

  createAndComposeScenes: ->
    rootElement = document.getElementById(@rootElementId)
    return unless rootElement
    new EventEmitter(rootElement)

    stagesDataset = rootElement.dataset
    movieLoadElement = document.getElementById(stagesDataset["loadingStage"])
    movieFinishElement = document.getElementById(stagesDataset["finishedStage"])
    contentElement = document.getElementById(stagesDataset["contentStage"])

    movieDataset = document.getElementById(rootElement.dataset["movieStage"]).dataset
    screenElement = document.getElementById(movieDataset["screen"])
    stripElements = document.getElementById(movieDataset["strips"]).getElementsByClassName(movieDataset["stripsClass"])
    movie = Movie.createFromHTMLElement(screenElement, stripElements)

    createScene = (sceneElement) -> new Scene(new Stage(sceneElement))
    movieScene = createScene(screenElement)
    movieLoadScene = createScene(movieLoadElement)
    movieFinishScene = createScene(movieFinishElement)
    contentScene = createScene(contentElement)

    composeScenes(movie, movieScene, movieLoadScene, movieFinishScene, contentScene)
    @scenes = [movieLoadScene, movieScene, movieFinishScene, contentScene]

`export default MultiSceneMovie`
