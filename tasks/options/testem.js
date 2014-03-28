// See https://npmjs.org/package/grunt-contrib-testem for more config options
module.exports = {
  basic: {
    options: {
      parallel: 2,
      framework: 'jasmine2',
      port: (parseInt(process.env.PORT || 7358, 10) + 1),
      test_page: 'tmp/result/spec/index.html',
      routes: {
        '/spec/spec.js': 'tmp/result/spec/spec.js',
        '/assets/app.js': 'tmp/result/assets/app.js',
        '/assets/templates.js': 'tmp/result/assets/templates.js',
        '/assets/app.css': 'tmp/result/assets/app.css'
      },
      src_files: [
        'tmp/result/**/*.js'
      ],
      launch_in_dev: ['Chrome'],
      launch_in_ci: ['Chrome',
                     'ChromeCanary',
                     'Firefox',
                     'Safari',
                     'IE7',
                     'IE8',
                     'IE9'],
    }
  },
  browsers: {
    options: {
      parallel: 8,
      framework: 'jasmine2',
      port: (parseInt(process.env.PORT || 7358, 10) + 1),
      test_page: 'tmp/result/spec/index.html',
      routes: {
        '/spec/spec.js': 'tmp/result/spec/spec.js',
        '/assets/app.js': 'tmp/result/assets/app.js',
        '/assets/templates.js': 'tmp/result/assets/templates.js',
        '/assets/app.css': 'tmp/result/assets/app.css'
      },
      src_files: [
        'tmp/result/**/*.js'
      ],
      launch_in_dev: ['PhantomJS',
                     'Chrome',
                     'ChromeCanary',
                     'Firefox',
                     'Safari',
                     'IE7',
                     'IE8',
                     'IE9'],
      launch_in_ci: ['PhantomJS',
                     'Chrome',
                     'ChromeCanary',
                     'Firefox',
                     'Safari',
                     'IE7',
                     'IE8',
                     'IE9'],
    }
  }
};
