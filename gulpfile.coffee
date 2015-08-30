browserify  = require 'browserify'
del         = require 'del'
browserSync = require 'browser-sync'
gulp        = require 'gulp'
cjsx        = require 'gulp-cjsx'
coffee      = require 'gulp-coffee'
lint        = require 'gulp-coffeelint'
plumber     = require 'gulp-plumber'
rename      = require 'gulp-rename'
sass        = require 'gulp-sass'
minifyCSS   = require 'gulp-minify-css'
uglify      = require 'gulp-uglify'
gutil       = require 'gulp-util'
watch       = require 'gulp-watch'
Server      = (require 'karma').Server
merge2      = require 'merge2'
source      = require 'vinyl-source-stream'
buffer      = require 'vinyl-buffer'
watchify    = require 'watchify'

gulp.task 'browser-sync', ->
  browserSync.init null,
    open: true
    server:
      baseDir: '.'
    watchOptions:
      debounceDelay: 1000

gulp.task 'sass', ->
  gulp.src('sass/**/*.sass')
    .pipe(plumber())
    .pipe(sass({ style: 'compressed', loadPath: ['./sass'] }))
    .pipe(minifyCSS({ processImport: true, relativeTo: 'sass' }))
    .pipe(rename 'hawker-hub.min.css')
    .pipe(gulp.dest('dist'))

gulp.task 'lint', ->
  gulp.src('coffee/**/*.coffee')
    .pipe(lint())
    .pipe(lint.reporter())
  gulp.src('test/**/*.coffee')
    .pipe(lint())
    .pipe(lint.reporter())

gulp.task 'cjsx', ->
  gulp.src('coffee/**/*.cjsx')
    .pipe(plumber())
    .pipe(cjsx({bare: true}))
    .pipe(gulp.dest 'js')

gulp.task 'coffee', ['lint'], ->
  gulp.src('coffee/**/*.coffee')
    .pipe(plumber())
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest 'js')

gulp.task 'coffee_test', ['lint'], ->
  gulp.src('test/**/*.coffee')
    .pipe(plumber())
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest 'js_test')

gulp.task 'watch', ['coffee', 'cjsx'], ->
  gulp.watch 'coffee/**/*.coffee', ['coffee']
  gulp.watch 'coffee/**/*.cjsx', ['cjsx']
  gulp.watch 'test/**/*.coffee', ['test']
  gulp.watch 'sass/**/*.sass', ['sass']
  gulp.watch 'dist/**/**', (file) ->
    browserSync.reload(file.path) if file.type is 'changed'

gulp.task 'browserify', ['coffee', 'cjsx'], ->
  config =
    packageCache: {}
    cache: {}
    entries: ['js/index.js']
    debug: false
  bundler = watchify (browserify config)
  rebundle = ->
    bundler.bundle()
      .on('error', gutil.log.bind(gutil, 'Browserify Error'))
      .pipe(source 'hawker-hub.js')
      .pipe(buffer())
      .pipe(gulp.dest './dist')
  bundler.on 'update', rebundle
  rebundle()

gulp.task 'test', ['coffee', 'coffee_test'], (done) ->
  config =
    configFile: __dirname + '/karma.conf.js'
    singleRun: true
  (new Server config, -> done()).start()

gulp.task 'clean', -> del(['dist', 'js'])
gulp.task 'default', ['sass', 'watch', 'browserify', 'browser-sync']
