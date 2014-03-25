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

`export default AppearanceDetector`
