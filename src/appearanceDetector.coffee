class AppearanceDetector
  constructor: (@element) ->
    @wasVisible = false
    @detect()

  viewportHeight: -> window.innerHeight
  viewportTop: -> window.scrollY
  viewportBottom: -> @viewportTop() + @viewportHeight()
  elementTop: -> @element.getBoundingClientRect().top
  elementBottom: -> @elementTop() + @element.getBoundingClientRect().height

  topVisible: ->
    @elementTop() > 0 && @elementTop() < @viewportBottom()

  bottomVisible: ->
    @elementBottom() > 0 && @elementBottom() < @viewportBottom()

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

`export default AppearanceDetector`
