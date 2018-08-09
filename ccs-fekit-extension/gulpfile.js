'use strict';

const gulp = require('gulp');
const runsequence = require('run-sequence');
const sass = require('gulp-sass');
const sassLint = require('gulp-sass-lint');


gulp.task('default', [ 'dev' ]);

gulp.task('dev', cb => {
    runsequence(
        'lint-sass',
        'sass',
        'js',
        cb
    )
});

gulp.task('sass', function () {
    return gulp.src('./src/scss/*.scss')
        .pipe(sass({
            includePaths: './node_modules'
        }))
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('./package'));
});

gulp.task('js', function () {
    return gulp.src('./node_modules/govuk-frontend/all.js')
        .pipe(gulp.dest('./package'));
});

gulp.task('lint-sass', function () {
    return gulp.src('src/scss/**/*.s+(a|c)ss')
        .pipe(sassLint())
        .pipe(sassLint.format())
        .pipe(sassLint.failOnError())
});

