var Helpers = require('../helpers'),
    filterAvailable = Helpers.filterAvailableTasks,
    LIVERELOAD_PORT = 35729,
    liveReloadPort = (parseInt(process.env.PORT || 8000, 10) - 8000) + LIVERELOAD_PORT;

var scripts = '{src,spec,config}/**/*.{js,coffee,em}',
    templates = 'src/templates/**/*.{hbs,handlebars,hjs,emblem}',
    sprites = 'src/sprites/**/*.{png,jpg,jpeg}',
    styles = 'src/styles/**/*.{css,sass,scss,less,styl}',
    indexHTML = 'src/index.html',
    other = '{src,spec,public}/**/*',
    bowerFile = 'bower.json',
    npmFile = 'package.json';

module.exports = {
  scripts: {
    files: [scripts],
    tasks: ['lock', 'buildScripts', 'unlock']
  },
  templates: {
    files: [templates],
    tasks: ['lock', 'buildTemplates:debug', 'unlock']
  },
  sprites: {
    files: [sprites],
    tasks: filterAvailable(['lock', 'fancySprites:create', 'unlock'])
  },
  styles: {
    files: [styles],
    tasks: ['lock', 'buildStyles', 'unlock']
  },
  indexHTML: {
    files: [indexHTML],
    tasks: ['lock', 'buildIndexHTML:debug', 'unlock']
  },
  other: {
    files: [other, '!'+scripts, '!'+templates, '!'+styles, '!'+indexHTML, bowerFile, npmFile],
    tasks: ['lock', 'build:debug', 'unlock']
  },

  options: {
    // No need to debounce
    debounceDelay: 0,
    // When we don't have inotify
    interval: 100,
    livereload: liveReloadPort
  }
};
