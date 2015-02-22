var gulp = require('gulp'),
    livereload = require('gulp-livereload'),
    less = require('gulp-less'),
    browserify = require('browserify'),
    source = require('vinyl-source-stream'),
    buffer = require('vinyl-buffer'),
    uglify = require('gulp-uglify'),
    sourcemaps = require('gulp-sourcemaps'),
    shell = require('gulp-shell');

gulp.task('sqs server', shell.task(['cd template && /Users/demianxyz/.nvm/v0.11.14/bin/sqs server']));

gulp.task('less', function () {
  gulp.src('./public/modules/app/style.less')
    .pipe(less())
    .pipe(gulp.dest('./template/styles/'))
    .pipe(livereload());
});

gulp.task('watch', function() {
  livereload.listen();
  gulp.watch('./public/modules/**/*.less', ['less']);
  gulp.watch('./public/modules/**/*.coffee', ['js']);
  gulp.watch(
    ['./template/**/*.region',
     './template/pages/*',
     './template/blocks/*',
     './template/assets/*',
     './template/collections/*'], ['sqs']);
});

gulp.task('sqs', function() {
  livereload.reload()
});

gulp.task('js', function() {
  browserify({
    entries: ['./public/modules/app/view.coffee'],
    extensions: ['.coffee'],
    debug: true
  })
  .transform('coffeeify')
  .transform('deamdify')
  .transform('debowerify')
  .transform('uglifyify')
  .bundle()
  .pipe(source('bundle.js'))
  .pipe(gulp.dest('./template/scripts/'))
  .pipe(livereload());
});

gulp.task('default', [
  'less',
  'js',
  'watch'
]);
