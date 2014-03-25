var grunt = require('grunt');

module.exports = {
  options: {
    whitelist: {
      'ember/resolver': ['default'],
      'ember-qunit': ['moduleForComponent', 'moduleFor', 'test', 'default'],
    }
  },

  app: {
    options: {
      moduleName: function (name) {
        return grunt.config.process('<%= package.namespace %>/') + name;
      }
    },
    files: [{
      expand: true,
      cwd: 'src',
      src: ['**/*.js']
    }]
  },

  tests: {
    options: {
      moduleName: function (name) {
        // Trim of the leading app/ from app modules
        if (name.slice(0, 4) === 'src/') {
          name = name.slice(4);
        }
        return grunt.config.process('<%= package.namespace %>/') + name;
      }
    },
    // Test files reference app files so we have to make sure we pull in both sets
    files: [{
      expand: true,
      cwd: '.',
      src: ['spec/**/*.js']
    }, {
      expand: true,
      cwd: '.',
      src: ['app/**/*.js']
    }]
  }
};
