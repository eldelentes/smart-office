gulp = require 'gulp'
sass = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'
notify = require 'gulp-notify'
browserSync = require 'browser-sync'
bs1 = browserSync.create("first server")
imagemin = require 'gulp-imagemin'
pngquant = require 'imagemin-pngquant'
coffee = require 'gulp-coffee'

# Paths
### You can also use a local url, in that case, use browserSync.init proxy: local ###
local = {  baseDir: "/"  }

srcs =
    scss: 'scss/**/*'
    img: 'images/*'
    coffee: 'scripts/*'
    html: '*.html'
    watch:
        scss: 'scss/**/*'
        coffee: 'scripts/*'
        html: '*.html'
        img: 'images/*'

dests =
    css: 'dist/css'
    img: 'dist/images'
    js: 'dist/js'
    html: 'dist/'

### Define all your source files here ###
sync =
    css: 'dist/css/**/*.css'
    html: 'dist/*.html'

# Tasks
### On each source file change, trigger a browsersync.reload ###
gulp.task 'browser-sync', ->
    bs1.init({
	    port: 3014,
	    server: "./dist"
	})
    gulp.watch(sync.css).on('change', bs1.reload)

gulp.task 'css', ->
    gulp.src srcs.scss
        .pipe sass({
            outputStyle: 'expand',
        }).on('error', (err) ->
            notify(title: 'CSS Task').write err.line + ': ' + err.message  
            this.emit('end');
        )
        .pipe autoprefixer(cascade: false, browsers: ['> 4%'])
        .pipe gulp.dest dests.css

gulp.task 'coffee', ->
    gulp.src srcs.coffee
        .pipe gulp.dest dests.js

gulp.task 'media', ->
    gulp.src srcs.img
        .pipe imagemin({
        	progressive: true
        	use: [pngquant()]
        })
        .pipe gulp.dest dests.img

gulp.task 'watch', ->
    gulp.watch srcs.watch.scss, ['css']
    gulp.watch srcs.watch.coffee, ['coffee']
    gulp.watch srcs.watch.html, ['html']
    gulp.watch srcs.watch.img, ['media']

gulp.task 'html', ->
    gulp.src srcs.html
        .pipe gulp.dest dests.html
        read: false

gulp.task 'default', ['html', 'css','coffee', 'media', 'browser-sync', 'watch']