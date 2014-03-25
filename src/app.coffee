#multi scene movie sample application

`import Movie from "multiSceneMovie/movie"`
`import Stage from "multiSceneMovie/stage"`
`import MovieStage from "multiSceneMovie/movieStage"`
`import Scene from "multiSceneMovie/scene"`

$( ()->
  screenElement = document.getElementById('movie')
  stripElements = document.getElementById('movie_strips').getElementsByClassName('strip')
  movie = Movie.createFromHTMLElement(screenElement, stripElements)

  moviePlayStage = new MovieStage(movie)
  movieScene = new Scene(moviePlayStage)
  movieScene.finish()

  movieLoadStage = new Stage($(".movie_control.loading")[0])
  movieLoadScene = new Scene(movieLoadStage)
  movieLoadScene.sceneDidStart = movie.loadMovie
  movieLoadScene.start()

  movieFinishStage = new Stage($(".movie_control.finished")[0])
  movieFinishScene = new Scene(movieFinishStage)
  movieFinishScene.finish()

  movie.movieDidLoad = ->
    movieLoadScene.finish()
    movieScene.start()

  movie.movieDidFinish = ->
    movieScene.finish()
    movieFinishScene.start()

  contentStage = new Stage(document.getElementById('contents'))
  contentScene = new Scene(contentStage)
  movieScene.sceneDidFinish = contentScene.start

  movieScene.sceneDidStart = ->
    movie.rewind()
    movie.play() if @stage.detectAppearance()

  $(document).bind('scroll', moviePlayStage.detectAppearance)
  $('#contents .button_region').bind('click', contentScene.finish)
  $('.movie_control.finished').bind('click',->
    movieFinishScene.finish()
    movieScene.start()
  )
)
