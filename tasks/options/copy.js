module.exports = {

  // Note: These tasks are listed in the order in which they will run.

  javascriptToTmp: {
    files: [{
      expand: true,
      cwd: 'src',
      src: '**/*.js',
      dest: 'tmp/javascript/src'
    },
    {
      expand: true,
      cwd: 'spec',
      src: ['**/*.js', '!test-helper.js', '!test-loader.js'],
      dest: 'tmp/javascript/spec/'
    },
    {
      expand: true,
      cwd: 'spec',
      src: ['fixtures/*'],
      dest: 'tmp/result/spec/'
    }
    ]
  },

  cssToResult: {
    files: [{
      expand: true,
      cwd: 'src/styles',
      src: ['**/*.css'],
      dest: 'tmp/result/assets'
    }, {
      expand: true,
      cwd: 'src/images',
      src: ['**/*.{png,gif,jpg,jpeg}'],
      dest: 'tmp/result/assets'
    }
    ]
  },

  // Assembles everything in `tmp/result`.
  // The sole purpose of this task is to keep things neat. Gathering everything in one
  // place (tmp/dist) enables the subtasks of dist to only look there. Note: However,
  // for normal development this is done on the fly by the development server.
  assemble: {
    files: [{
      expand: true,
      cwd: 'spec',
      src: ['test-helper.js', 'test-loader.js'],
      dest: 'tmp/result/spec/'
    }, {
      expand: true,
      cwd: 'public',
      src: ['**'],
      dest: 'tmp/result/'
    }, {
      src: ['vendor/**/*.js', 'vendor/**/*.css'],
      dest: 'tmp/result/'
    }, {
      src: ['config/environment.js', 'config/environments/production.js'],
      dest: 'tmp/result/'
    }

    ]
  },

  imageminFallback: {
    files: '<%= imagemin.dist.files %>'
  },

  dist: {
    files: [{
      expand: true,
      cwd: 'tmp/result',
      src: [
        '**',
        '!**/*.{css,js}', // Already handled by concat
        '!**/*.{png,gif,jpg,jpeg}', // Already handled by imagemin
        '!spec/**/*', // No tests, please
        '!**/*.map' // No source maps
      ],
      filter: 'isFile',
      dest: 'dist/'
    }]
  },
};
