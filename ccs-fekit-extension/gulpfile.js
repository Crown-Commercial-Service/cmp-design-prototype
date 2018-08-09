'use strict';

const gulp = require('gulp')
const runsequence = require('run-sequence')
const clean = require('gulp-clean');
const sass = require('gulp-sass');
const sassLint = require('gulp-sass-lint');


gulp.task('default', [ 'dev' ]);

gulp.task('dev', cb => {
    runsequence(
        'gov-assets',
        'ccs-assets',
        'clean-gov',
        'compile-sass',
        'lint-sass',
        'clean-package',
        'package-assets',
        cb
    )
});

// get the whole asset package to temp from gov.uk kit
gulp.task('gov-assets', function () {
    return gulp.src('./node_modules/govuk-frontend/**')
        .pipe(gulp.dest('./temp'));
});

// copy local assets to temp for building
gulp.task('ccs-assets', function () {
    return gulp.src('./src/**')
        .pipe(gulp.dest('./temp'));
});

// delete all compiled css so we can recompiler
gulp.task('clean-gov', function () {
    return gulp.src('./temp/**/*.css')
        .pipe(clean());
});

gulp.task('compile-sass', function () {
    return gulp.src('./temp/*.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('./temp'));
});

gulp.task('package-assets', function () {
    return gulp.src('./temp/**')
        .pipe(gulp.dest('./package'));
});

gulp.task('clean-package', function () {
    return gulp.src('./package/**')
        .pipe(clean());
});

gulp.task('lint-sass', function () {
    return gulp.src('temp/ccs*/*.s+(a|c)ss')
        .pipe(sassLint())
        .pipe(sassLint.format())
        .pipe(sassLint.failOnError())
});


gulp.task('clean', function () {
    return gulp.src('temp', {read: false})
        .pipe(clean());
});

