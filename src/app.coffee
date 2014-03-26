#multi scene movie sample application

`import Movie from "multiSceneMovie/movie"`
`import Stage from "multiSceneMovie/stage"`
`import MovieStage from "multiSceneMovie/movieStage"`
`import Scene from "multiSceneMovie/scene"`

composeAll = ->

$( ()->

  createMoviePlayScene = (movie)->
    moviePlayStage = new MovieStage(movie)
    movieScene = new Scene(moviePlayStage)
    movieScene.finish()
    movieScene

  createMovieLoadingScene = (loadingSceneElement, movie) ->
    movieLoadStage = new Stage(loadingSceneElement)
    movieLoadScene = new Scene(movieLoadStage)
    movieLoadScene

  createMovieFinishScene = (finishSceneElement) ->
    movieFinishStage = new Stage(finishSceneElement)
    movieFinishScene = new Scene(movieFinishStage)
    movieFinishScene.finish()
    movieFinishScene

  createContentScene = (contentSceneElement) ->
    contentStage = new Stage(contentSceneElement)
    contentScene = new Scene(contentStage)
    contentScene

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

    $(document).bind("scroll", movieScene.stage.detectAppearance)
    $(movieFinishScene.stage.element).bind("click", ->
      movieFinishScene.finish()
      movieScene.start()
    )

    movieLoadScene.start()
    [movieLoadScene, movieScene, movieFinishScene, contentScene]

  return unless document.getElementById("stages_container")

  stagesDataset = document.getElementById("stages_container").dataset
  movieLoadElement = document.getElementById(stagesDataset["loadingStage"])
  movieFinishElement = document.getElementById(stagesDataset["finishedStage"])
  contentElement = document.getElementById(stagesDataset["contentStage"])

  movieDataset = document.getElementById(document.getElementById("stages_container").dataset["movieStage"]).dataset
  screenElement = document.getElementById(movieDataset["screen"])
  stripElements = document.getElementById(movieDataset["strips"]).getElementsByClassName(movieDataset["stripsClass"])
  window.movie = Movie.createFromHTMLElement(screenElement, stripElements)

  window.movieScene = createMoviePlayScene(movie)
  window.movieLoadScene = createMovieLoadingScene(movieLoadElement, movie)
  movieFinishScene = createMovieFinishScene(movieFinishElement)
  contentScene = createContentScene(contentElement)

  composeAll = -> composeScenes(movie, movieScene, movieLoadScene, movieFinishScene, contentScene)
)
`export default composeAll`
