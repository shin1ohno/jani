class AppearanceDetector
  constructor: (@element, @topMargin=90, @bottomMargin=90) ->
    @wasVisible = false
    @detect()

  viewportHeight: -> window.innerHeight
  viewportTop: -> window.scrollY
  viewportBottom: -> @viewportHeight()
  elementTop: -> @element.getBoundingClientRect().top
  elementBottom: -> @element.getBoundingClientRect().bottom

  topVisible: ->
    @elementTop() + @topMargin > 0 && @elementTop() + @topMargin < @viewportBottom()

  bottomVisible: ->
    @elementBottom() - @bottomMargin > 0 && @elementBottom() - @bottomMargin < @viewportBottom()

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
