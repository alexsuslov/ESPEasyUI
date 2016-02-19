var gulp = require('gulp');
var jade = require('gulp-jade');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var clean = require('gulp-clean');
var watch = require('gulp-watch');
var webserver = require('gulp-webserver');

gulp.task('default', ['coffee','compress','jade', 'watch', 'webserver']);

gulp.task('coffee', function() {
  return gulp.src('./coffee/*.coffee')
    .pipe(coffee({bare: true}))
      // .on('error', gutil.log))
    .pipe(gulp.dest('.tmp/js/'));
});

gulp.task('compress',['coffee'], function() {
  return gulp.src(['js/*.js','.tmp/js/*.js'])
    .pipe(uglify())
    .pipe(gulp.dest('.tmp/min/'));
});

gulp.task('jade', ['compress'], function() {
  var YOUR_LOCALS = {
    title:'ESP Easy.',
    footer: "Powered by 42do.ru"
  };

  return gulp.src('./jade/*.jade')
    .pipe(jade({
      locals: YOUR_LOCALS
    }))
    .pipe(gulp.dest('.tmp/'))
});

gulp.task('clean', function () {
  return gulp.src(['.tmp'], {read: false})
    .pipe(clean());
});


gulp.task('watch', function () {
  gulp.watch('coffee/**/*.coffee', ['coffee'])
  gulp.watch('.tmp/js/**/*.js', ['compress'])
  gulp.watch('dist/**/*.js', ['jade'])
  gulp.watch(['jade/**/*.jade','.tmp/js/*.js'], ['jade']);
});

gulp.task('webserver', function() {
  gulp.src('.tmp')
    .pipe(webserver({
      livereload: true,
      directoryListing: true,
      open: false
    }));
});

