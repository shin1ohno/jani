`import Screen from "multiSceneMovie/screen"`

describe "screen", ->
  beforeEach ->
    jasmine.getFixtures().fixturesPath = "fixtures"
    loadFixtures("movie.html")

  it "has no bg image when no default image specified", ->
    element = $(".movie")[0]
    element.dataset["defaultImage"] = ""
    screen = new Screen(element)
    expect(screen.element.style.cssText).not.toMatch("background-image:")

  it "has bg image when default image specified", ->
    element = $(".movie")[0]
    url = "http://example.com/bg.jpg"
    element.dataset["defaultImage"] = url
    screen = new Screen(element)
    expect(screen.element.style.cssText).toMatch(url)
