`import Stage from "multiSceneMovie/stage"`

describe "Stage", ->
  it "has appearance detector", ->
    jasmine.getFixtures().fixturesPath = "fixtures"
    loadFixtures("movie.html")
    stage = new Stage(document.getElementById("loading_scene"))
    expect(stage.detectAppearance()).toEqual true
