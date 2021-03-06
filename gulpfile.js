var gulp = require('gulp');
var sass = require('gulp-sass');

// Common paths.
var paths = {
    BootstrapSCSS: 'priv/assets/bootstrap-custom/bootstrap-custom.scss',
    BootstrapInclude: 'priv/components/bootstrap-sass/assets/stylesheets',
}

// Build admin CSS from SASS/CSS
gulp.task('sass', function() {
    return gulp.src(paths.BootstrapSCSS)
    .pipe(sass({
        trace: true,
        style: 'compressed',
        includePaths: [paths.BootstrapInclude]
    }))
    .pipe(gulp.dest('priv/static/css'));
});

// Watch for changes.
gulp.task('watch', function () {
    gulp.watch(paths.BootstrapSCSS, ['sass']);
});

// Default gulp task.
gulp.task('default', ['sass']);
