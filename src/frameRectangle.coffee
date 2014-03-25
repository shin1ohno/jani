class FrameRectangle
  constructor: (@leftPosition, @topPosition) ->
  toCssText: ->
    "background-position: #{@leftPosition}px #{@topPosition}px;"

`export default FrameRectangle`
