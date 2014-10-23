`import RequestBuffer from "multiSceneMovie/requestBuffer"`

class Beacon
  constructor: (url, type) ->
    requestBuffer = new RequestBuffer(type)
    requestBuffer.push(url)

`export default Beacon`
