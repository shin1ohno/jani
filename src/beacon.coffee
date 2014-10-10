`import RequestBuffer from "multiSceneMovie/requestBuffer"`

class Beacon
  constructor: (url) ->
    requestBuffer = new RequestBuffer()
    requestBuffer.push(url)

`export default Beacon`
