var grunt = require('grunt');

module.exports = {
  "tests": {
    type: 'amd',
    moduleName: function(path) {
      return grunt.config.process('<%= package.namespace %>/spec/') + path;
    },
    files: [{
      expand: true,
      cwd: 'tmp/javascript/spec/',
      src: '**/*.js',
      dest: 'tmp/transpiled/spec/'
    }]
  },
  "app": {
    type: 'amd',
    moduleName: function(path) {
      return grunt.config.process('<%= package.namespace %>/') + path;
    },
    files: [{
      expand: true,
      cwd: 'tmp/javascript/app/',
      src: '**/*.js',
      dest: 'tmp/transpiled/app/'
    }]
  }
};
