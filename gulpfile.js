var gulp = require('gulp'),
    gutil = require('gulp-util'),
    nodemon = require('gulp-nodemon'),
    livereload = require('gulp-livereload'),
    less = require('gulp-less'),
    browserify = require('browserify'),
    source = require('vinyl-source-stream'),
    buffer = require('vinyl-buffer'),
    uglify = require('gulp-uglify'),
    sourcemaps = require('gulp-sourcemaps');

gulp.task('less', function () {
  gulp.src('./public/modules/app/style.less')
    .pipe(less())
    .pipe(gulp.dest('./public/css'))
    .pipe(livereload());
});

gulp.task('watch', function() {
  gulp.watch('./public/modules/**/*.less', ['less']);
  gulp.watch('./public/modules/**/*.coffee', ['js']);
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
  //.transform('uglifyify')
  .bundle()
  .pipe(source('bundle.js'))
  .pipe(gulp.dest('./public/js/'))
});

gulp.task('develop', function () {
  livereload.listen();
  nodemon({
    script: 'app.js',
    ext: 'js coffee jade'
  }).on('restart', function () {
    setTimeout(function () {
      livereload.changed();
    }, 500);
  });
});

gulp.task('default', [
  'less',
  'develop',
  'js',
  'watch'
]);
