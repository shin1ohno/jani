module.exports = {
  compile: {
    files: [{
      expand: true,
      cwd: 'src/styles',
      src: ['**/*.{scss,sass}', '!**/_*.{scss,sass}'],
      dest: 'tmp/result/assets/',
      ext: '.css'
    }]
  }
};
