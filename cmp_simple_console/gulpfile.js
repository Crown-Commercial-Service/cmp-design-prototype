'use strict';

const gulp = require('gulp');
const runsequence = require('run-sequence');
const sass = require('gulp-sass');
const sassLint = require('gulp-sass-lint');
const clean = require('gulp-clean');

gulp.task('default', [ 'dev' ]);

gulp.task('dev', cb => {
    runsequence(
        'ccs-ccskit-scss',
        'ccs-ccskit-js',
        'ccs-ccskit-assets',
        'ccs-ccskit-server-kit-side',
        cb
    )
});

// compile frontend kit SCSS into usable css
gulp.task('ccs-ccskit-scss', function () {
    return gulp.src('node_modules/ccs-frontend-prototype/*.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('./public/'));
});

gulp.task('ccs-ccskit-js', function () {
    return gulp.src('node_modules/ccs-frontend-prototype/*.js')
        .pipe(gulp.dest('./public/'));
});

// copy shared assets into publc
gulp.task('ccs-ccskit-assets', function () {
    return gulp.src('node_modules/ccs-frontend-prototype/assets/**')
        .pipe(gulp.dest('./public/assets'));
});

// copy everything (templates and scss) into server-kit side assets
gulp.task('ccs-ccskit-server-kit-side', function () {
    return gulp.src('node_modules/ccs-frontend-prototype/**')
        .pipe(gulp.dest('./server-kit'));
});

gulp.task('clean', function () {
    return gulp.src(['public', 'server-kit'], {read: false})
        .pipe(clean());
});

