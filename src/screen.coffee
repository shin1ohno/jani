class Screen
  constructor: (@element) ->
    @setDefaultImage()

  setStrips: (@strips) ->

  setDefaultImage: ->
    if @defaultImageUrl()
      defaultStyle = @element.style.cssText
      @element.style.cssText = defaultStyle + "background-image: url(#{@defaultImageUrl()}); background-size: cover;　background-repeat: no-repeat;"

  defaultImageUrl: ->
    url = @element.dataset["defaultImage"]
    if url == ""
      undefined
    else
      url

  showCurrentFrame: ->
    defaultStyle = @element.style.cssText
    @element.style.cssText = defaultStyle + @currentStrip().toCssText()
  currentStrip: -> @strips[0] #TODO: implement multi strip

`export default Screen`
