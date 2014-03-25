// TODO: load based on params
[
  "multiSceneMovie/spec/movieSpec",
  "multiSceneMovie/spec/multiSceneCompositionSpec"
].forEach(function(moduleName) {
  require(moduleName, null, null, true);
});
