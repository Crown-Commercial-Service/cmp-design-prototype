'use strict';

const express = require('express')
const app = express()
const nunjucks = require('nunjucks')
const request = require('superagent');
var bodyParser = require('body-parser');


// Set up views
const appViews = [
    "views",
    "../ccs-fekit-extension/src/", // this hack allows us to prototype changes in fekit without having to redeploy via npm
    "../ccs-fekit-extension/package/", // this hack allows us to prototype changes in fekit without having to redeploy via npm
    "server-kit",
    "server-kit/components",
];

function search(path = '/', renderfn) {
    request.get("http://localhost:9200/" + path).timeout(500)
        .end((err, res) => {
            if (err) {
                console.log(' search error "' + err);
                renderfn('no result at ' + '/');
            } else if (200 == res.statusCode) {
                console.log(' search results "' + JSON.stringify(res.body));
                renderfn(res.body);
            }
        });
}

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
        serviceName: "Example Framework",
        ...nunjucksOptions, // merge any additional options and overwrite defaults above.
    })


    // Set view engine
    app.set('view engine', 'njk')

    // Set up middleware to serve static assets
    app.use('/govuk-frontend', express.static('public'))
    app.use('/', express.static('public'))
    app.use(bodyParser.urlencoded({ extended: false }));


    // Add middleware to resolve local internationalisation values to configure app
    app.use(function (req, res, next) {
        res.locals = {
            serviceName: "Example Framework",
        };
        next();
    });

    var status = [], results = [], query= "";
    search('/', sr => {
        status = JSON.stringify(sr);
        // Index page - render the component list template
        app.get('/', async function (req, res) {
            res.render('index', {backlink: false,
                query: query, results: results, status: status})
        })
    });

    app.post('/', async function (req, res) {
        query= req.body.search_text
        // var query = JSON.stringify(req.body.search_text);
        // console.log(query)
        search(query, sr => {
            results = JSON.stringify(sr);
        });
        res.redirect('/#search')
    });

    return app
}