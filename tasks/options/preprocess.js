module.exports = {
  indexHTMLDebugApp: {
    src : 'src/index.html', dest : 'tmp/result/index.html',
    options: { context: { dist: false, tests: false } }
  },
  indexHTMLDebugTests: {
    src : 'src/index.html', dest : 'tmp/result/spec/index.html',
    options: { context: { dist: false, tests: true } }
  },
  indexHTMLDistApp: {
    src : 'src/index.html', dest : 'tmp/result/index.html',
    options: { context: { dist: true, tests: false } }
  },
  indexHTMLDistTests: {
    src : 'src/index.html', dest : 'tmp/result/spec/index.html',
    options: { context: { dist: true, tests: true } }
  }
};
