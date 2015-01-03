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

var getBundleName = function () {
  var version = require('./package.json').version;
  var name = require('./package.json').name;
  return name + '.' + version + '.' + 'min';
};

var exitOnError = false;

function handleError(err) {
  var displayErr = gutil.colors.red(err);
  gutil.log(displayErr);
  if (exitOnError) process.exit(1);
}

gulp.task('less', function () {
  gulp.src('./public/css/style.less')
    .pipe(less())
    .pipe(gulp.dest('./public/css'))
    .pipe(livereload());
});

gulp.task('watch', function() {
  gulp.watch('./public/css/*.less', ['less']);
  gulp.watch('./public/js/**/*.coffee', ['js']);
});

gulp.task('js', function() {
  browserify({
    entries: ['./public/js/app.coffee'],
    extensions: ['.coffee', '.js']
  })
  .on('error', handleError)
  .transform('coffeeify')
  .on('error', handleError)
  .transform('deamdify')
  .on('error', handleError)
  .transform('debowerify')
  .on('error', handleError)
  //.transform('uglifyify')
  .bundle()
  .on('error', handleError)
  .pipe(source('bundle.js'))
  .pipe(gulp.dest('public/js/'))
});

gulp.task('develop', function () {
  livereload.listen();
  nodemon({
    script: 'app.js',
    ext: 'js coffee jade',
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
