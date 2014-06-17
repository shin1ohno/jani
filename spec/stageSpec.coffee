`import Stage from "multiSceneMovie/stage"`

describe "Stage", ->
  it "has appearance detector", ->
    jasmine.getFixtures().fixturesPath = "fixtures"
    loadFixtures("movie.html")
    stage = new Stage(document.getElementsByClassName("loading_scene")[0])
    expect(stage.appearanceDetector.constructor.name).toEqual "AppearanceDetector"
