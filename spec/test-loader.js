// TODO: load based on params
[
  "multiSceneMovie/spec/movieSpec",
  "multiSceneMovie/spec/screenSpec",
  "multiSceneMovie/spec/stageSpec",
  "multiSceneMovie/spec/eventEmitterSpec",
  "multiSceneMovie/spec/multiSceneCompositionSpec"
].forEach(function(moduleName) {
  require(moduleName, null, null, true);
});
