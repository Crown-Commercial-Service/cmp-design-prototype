'use strict';

const gulp = require('gulp')
const runsequence = require('run-sequence')
const clean = require('gulp-clean');
const replace = require('gulp-replace');
const sassLint = require('gulp-sass-lint');


gulp.task('default', [ 'dev' ]);

gulp.task('dev', cb => {
    runsequence(
        'copy-govkit',
        'copy-ccs',
        'transform-scss-to-ccs',
        'transform-njk-to-ccs',
        'lint-sass',
        'package',
        cb
    )
});

// get the whole asset package to temp from gov.uk kit
gulp.task('copy-govkit', function () {
    return gulp.src('./node_modules/govuk-frontend/**')
        .pipe(gulp.dest('./temp'));
});

// copy local assets to temp for building
gulp.task('copy-ccs', function () {
    return gulp.src('./src/**')
        .pipe(gulp.dest('./temp'));
});

// as a terrible hack, to prevent having to rewrite root stylesheets,
// we replace bits of text in the GOV.UK resources. This is just to
// get the right visiual effect with minimal effort - a better method
// is of course needed.
gulp.task('transform-scss-to-ccs', function () {
    return gulp.src('./temp/**/*.scss')
        .pipe(replace(
            '$govuk-brand-colour: govuk-colour("blue")',
            '$govuk-brand-colour: govuk-colour("pink")'))
        .pipe(replace(
            'govuk-crest.png',
            'CCS_WHITE_SML_AW.png'))
        .pipe(replace(
            'govuk-crest-2x.png',
            'CCS_WHITE_SML_AW.png'))
        .pipe(gulp.dest('./temp'));
});

// as a terrible hack, to prevent having to rewrite root templates,
// we replace bits of text in the GOV.UK resources. This is just to
// get the right visiual effect with minimal effort - a better method
// is of course needed.
gulp.task('transform-njk-to-ccs', function () {
    return gulp.src('./temp/**/*.njk')
        .pipe(replace(
            // page title in main template
            'GOV.UK - The best place to find government services and information',
            'CCS - CMP prototype'))
        .pipe(replace(
            // should just catch the text in header templates
            'GOV.UK',
            'Crown Commercial Service'))
        .pipe(gulp.dest('./temp'));
});

gulp.task('package', function () {
    return gulp.src('./temp/**')
        .pipe(gulp.dest('./package'));
});


gulp.task('lint-sass', function () {
    return gulp.src('temp/ccs*/*.s+(a|c)ss')
        .pipe(sassLint())
        .pipe(sassLint.format())
        .pipe(sassLint.failOnError())
});

gulp.task('clean', function () {
    return gulp.src(['temp', 'package'], {read: false})
        .pipe(clean());
});

