#multi scene movie sample application

`import Movie from "multiSceneMovie/movie"`
`import Stage from "multiSceneMovie/stage"`
`import MovieStage from "multiSceneMovie/movieStage"`
`import Scene from "multiSceneMovie/scene"`

composed = undefined

$( ()->

  createMoviePlayScene = (movie)->
    moviePlayStage = new MovieStage(movie)
    movieScene = new Scene(moviePlayStage)
    movieScene.finish()
    movieScene

  createMovieLoadingScene = (loadingSceneElement, movie) ->
    movieLoadStage = new Stage(loadingSceneElement)
    movieLoadScene = new Scene(movieLoadStage)
    movieLoadScene.sceneDidStart = movie.loadMovie
    movieLoadScene.start()
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
    movie.movieDidLoad = ->
      movieLoadScene.finish()
      movieScene.start()

    movie.movieDidFinish = ->
      movieScene.finish()
      movieFinishScene.start()

    movieScene.sceneDidStart = ->
      movie.rewind()
      movie.play() if @stage.detectAppearance()

    movieScene.sceneDidFinish = contentScene.start

    $(document).bind('scroll', movieScene.stage.detectAppearance)
    $(movieFinishScene.stage.element).bind('click', ->
      movieFinishScene.finish()
      movieScene.start()
    )

    [movieLoadScene, movieScene, movieFinishScene, contentScene]

  screenElement = document.getElementById('movie')
  stripElements = document.getElementById('movie_strips').getElementsByClassName('strip')
  movieLoadElement = $(".movie_control.loading")[0]
  movieFinishElement = $(".movie_control.finished")[0]
  contentElement = document.getElementById('contents')

  movie = Movie.createFromHTMLElement(screenElement, stripElements)
  movieScene = createMoviePlayScene(movie)
  movieLoadScene = createMovieLoadingScene(movieLoadElement, movie)
  movieFinishScene = createMovieFinishScene(movieFinishElement)
  contentScene = createContentScene(contentElement)
  composed = composeScenes(movie, movieScene, movieLoadScene, movieFinishScene, contentScene)
)
`export default composed`
