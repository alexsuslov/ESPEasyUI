var gulp = require('gulp');
var jade = require('gulp-jade');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglify');
var clean = require('gulp-clean');
var watch = require('gulp-watch');
var exec = require('gulp-exec');
var debug = require('gulp-debug');
var path = require('path');
var foreach = require('gulp-foreach');

gulp.task('default', ['coffee','compress','jade', 'watch']);
gulp.task('dist', ['clean', 'jade']);


gulp.task('jade', ['compress'], function() {
  var YOUR_LOCALS = {
    title:'ESP Easy.',
    footer: "Powered by 42do.ru"
  };
  return gulp.src('./jade/*.jade')
    .pipe(jade({
      locals: YOUR_LOCALS
    }))
    .pipe(gulp.dest('./html/'))
});


gulp.task('coffee', function() {
  return gulp.src('./coffee/*.coffee')
    .pipe(coffee({bare: false}).on('error', gutil.log))
    .pipe(gulp.dest('./js/'));
});


gulp.task('compress',['coffee'], function() {
  return gulp.src('js/*.js')
    .pipe(uglify())
    .pipe(gulp.dest('dist'));
});


gulp.task('clean', function () {
  return gulp.src(['dist', 'html'], {read: false})
    .pipe(clean());
});


gulp.task('watch', function () {
  gulp.watch('coffee/**/*.coffee', ['coffee'])
  gulp.watch('js/**/*.js', ['compress'])
  gulp.watch('dist/**/*.js', ['jade'])
  gulp.watch('jade/**/*.jade', ['jade']);
});