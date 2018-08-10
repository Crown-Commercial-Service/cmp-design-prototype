const express = require('express')
const app = express()
const nunjucks = require('nunjucks')
// const util = require('util')
// const fs = require('fs')
// const path = require('path')


// Set up views
const appViews = [
    "app/views",
    "public/",
    "public/components/"
]

module.exports = (options) => {
    const nunjucksOptions = options ? options.nunjucks : {}

    // Configure nunjucks
    let env = nunjucks.configure(appViews, {
        autoescape: true, // output with dangerous characters are escaped automatically
        express: app, // the express app that nunjucks should install to
        noCache: true, // never use a cache and recompile templates each time
        trimBlocks: true, // automatically remove trailing newlines from a block/tag
        lstripBlocks: true, // automatically remove leading whitespace from a block/tag
        watch: true, // reload templates when they are changed. needs chokidar dependency to be installed
        ...nunjucksOptions // merge any additional options and overwrite defaults above.
    })


    // Set view engine
    app.set('view engine', 'njk')

    // Set up middleware to serve static assets
    app.use('/govuk-frontend', express.static('public'))
    app.use('/public', express.static('public'))
    app.use('/assets', express.static('public/assets'))

    // Index page - render the component list template
    app.get('/', async function (req, res) {

        res.render('index', {})
    })

    return app
}