`import Stage from "multiSceneMovie/stage"`

describe "Stage", ->
  it "has appearance detector and default to false", ->
    jasmine.getFixtures().fixturesPath = "fixtures"
    loadFixtures("movie.html")
    stage = new Stage("loading_scene")
    expect(stage.detectAppearance()).toEqual false
