#multi scene movie sample application

`import Movie from "multiSceneMovie/movie"`
`import Stage from "multiSceneMovie/stage"`
`import MovieStage from "multiSceneMovie/movieStage"`
`import Scene from "multiSceneMovie/scene"`

createMovieScene = (movie)-> new Scene(new MovieStage(movie))

createScene = (sceneElement) -> new Scene(new Stage(sceneElement))

composeScenes = (movie, movieScene, movieLoadScene, movieFinishScene, contentScene) ->
  movieLoadScene.sceneDidStart = movie.loadMovie
  movieLoadScene.sceneDidFinish = movieScene.start

  movie.movieDidLoad = ->
    movieLoadScene.finish()

  movie.movieDidFinish = ->
    movieScene.finish()
    movieFinishScene.start()

  movieScene.sceneDidStart = ->
    movie.rewind()
    movie.play() if @stage.detectAppearance()

  movieScene.sceneDidFinish = contentScene.start

  document.addEventListener("scroll", movieScene.stage.detectAppearance, false)
  movieFinishScene.stage.element.addEventListener("click", ->
    movieFinishScene.finish()
    movieScene.start()
  , false)

  [movieLoadScene, movieScene, movieFinishScene, contentScene]

createAndComposeScenes = (containerElementId) ->
  return unless document.getElementById(containerElementId)

  stagesDataset = document.getElementById(containerElementId).dataset
  movieLoadElement = document.getElementById(stagesDataset["loadingStage"])
  movieFinishElement = document.getElementById(stagesDataset["finishedStage"])
  contentElement = document.getElementById(stagesDataset["contentStage"])

  movieDataset = document.getElementById(document.getElementById(containerElementId).dataset["movieStage"]).dataset
  screenElement = document.getElementById(movieDataset["screen"])
  stripElements = document.getElementById(movieDataset["strips"]).getElementsByClassName(movieDataset["stripsClass"])
  movie = Movie.createFromHTMLElement(screenElement, stripElements)

  movieScene = createMovieScene(movie)
  movieLoadScene = createScene(movieLoadElement)
  movieFinishScene = createScene(movieFinishElement)
  contentScene = createScene(contentElement)

  composeScenes(movie, movieScene, movieLoadScene, movieFinishScene, contentScene)
  [movieLoadScene, movieScene, movieFinishScene, contentScene]

`export default createAndComposeScenes`
