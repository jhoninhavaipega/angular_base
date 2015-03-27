var gulp = require('gulp'),
    gutil = require('gulp-util'),
    concat = require('gulp-concat'),
    uglyfly = require('gulp-uglyfly'),
    coffee = require('gulp-coffee'),
    compass = require('gulp-compass'),
    watch = require('gulp-watch'),
    browserSync = require('browser-sync'),
    sourcemaps = require('gulp-sourcemaps'),
    reload = browserSync.reload;

gulp.task('coffee', function() {
  gulp.src('assets/javascripts/app/**/*.coffee')
      .pipe(sourcemaps.init())
      .pipe(concat('application.coffee'))
      .pipe(coffee({bare: true}).on('error', gutil.log))
      .pipe(sourcemaps.write())
      .pipe(gulp.dest('public/javascripts/'))
      .pipe(reload({stream:true}));
});

gulp.task('compass', function() {
  gulp.src('assets/stylesheets/**/*.scss')
      .pipe(compass({
        css: 'public/stylesheets',
        sass: 'assets/stylesheets',
        image: 'public/images',
        font: 'public/fonts',
        style: 'compressed',
        sourcemap: true
      }))
      .pipe(gulp.dest('public/stylesheets/'))
      .pipe(reload({stream:true}));
});

gulp.task('join', function() {
  gulp.src('assets/javascripts/libs/**/*.js')
      .pipe(sourcemaps.init())
      .pipe(concat('libs.js'))
      .pipe(sourcemaps.write())
      .pipe(gulp.dest('public/javascripts/libs'));
});

gulp.task('browser-sync', function() {
  browserSync({
    server: {
      baseDir: "./"
    }
  });
});

gulp.task('bs-reload', function () {
  browserSync.reload();
});

gulp.task('default', ['browser-sync', 'compass', 'coffee', 'join'], function() {
  gulp.watch('assets/stylesheets/**/*.scss', ['compass']);
  gulp.watch('assets/javascripts/app/**/*.coffee', ['coffee']);
  gulp.watch('assets/javascripts/libs/**/*.js', ['join']);
  gulp.watch("*.html").on("change", browserSync.reload);
  gulp.watch("public/**/*.html").on("change", browserSync.reload);
  gulp.watch("public/images").on("change", browserSync.reload);
});
