class Screen
  constructor: (@element) ->
  setStrips: (@strips) ->

  showCurrentFrame: ->
    defaultStyle = @element.style.cssText
    @element.style.cssText = defaultStyle + @currentStrip().toCssText()
  currentStrip: -> @strips[0] #TODO: implement multi strip

`export default Screen`
