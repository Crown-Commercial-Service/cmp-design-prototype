'use strict';

const gulp = require('gulp');
const runsequence = require('run-sequence');
const sass = require('gulp-sass');
const sassLint = require('gulp-sass-lint');


gulp.task('default', [ 'dev' ]);

gulp.task('dev', cb => {
    runsequence(
        // 'ccs-ccskit-js',
        'ccs-ccskit-js',
        'ccs-govkit-scss',
        'ccs-ccskit-scss',
        'ccs-deploy',
        cb
    )
});

gulp.task('ccs-ccskit-js', function () {
    return gulp.src('node_modules/ccs-frontend-prototype/*.js')
        .pipe(gulp.dest('./public/'));
});

gulp.task('ccs-govkit-js', function () {
    return gulp.src('node_modules/ccs-frontend-prototype/*.js')
        .pipe(gulp.dest('./public/'));
});

gulp.task('ccs-ccskit-scss', function () {
    return gulp.src('node_modules/ccs-frontend-prototype/*.css')
        .pipe(gulp.dest('./public/'));
});

gulp.task('ccs-ccskit-assets', function () {
    return gulp.src('node_modules/ccs-frontend-prototype/assets/**')
        .pipe(gulp.dest('./public/assets'));
});

gulp.task('compile-sass', function () {
    return gulp.src('./src/**/*.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('./temp'));
});
