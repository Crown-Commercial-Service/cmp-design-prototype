'use strict';

const express = require('express')
const app = express()
const nunjucks = require('nunjucks')
const request = require('superagent');
const bodyParser = require('body-parser');
const elasticsearch = require('elasticsearch');

var connectionString = process.env.SEARCHBOX_SSL_URL || 'localhost:9200';

var client = new elasticsearch.Client({
    host: connectionString
});

// Set up views
const appViews = [
    "views",
    "../ccs-fekit-extension/src/", // this hack allows us to prototype changes in fekit without having to redeploy via npm
    "../ccs-fekit-extension/package/", // this hack allows us to prototype changes in fekit without having to redeploy via npm
    "server-kit",
    "server-kit/components",
    "views/components",
];

function search(index, type, body, resultfn, errfn) {
    client.search({
        index: index,
        type: type,
        body: body
    }).then(resultfn, errfn);
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
    app.use(bodyParser.urlencoded({extended: false}));


    // Add middleware to resolve local internationalisation values to configure app
    app.use(function (req, res, next) {
        res.locals = {
            serviceName: "Example Framework",
        };
        next();
    });

    var status = {}, results = {}, needs_expr = {"service": "Teacher"}, agreement = "ST";

    app.get('/', async function (req, res) {
        res.render('index', {
            backlink: false,
            needs_expr: needs_expr, results: results, status: status, agreement: agreement,
            type: {
                // This could be generated from agreement definition
                "ST.AG": {
                    attribute: [
                        {name: "branch_name"},
                        {name: "branch_location"}]
                },
                "ST.MS": {
                    attribute: []
                }
            }
        })
    })

    app.post('/', async function (req, res) {
        needs_expr.service = req.body.service_name;
        needs_expr.postcode = req.body.postcode;
        var qry = {
            "query": {
                "multi_match": {
                    "query": needs_expr.service + "  " + needs_expr.postcode,
                    "fields": [
                        "id", "name^2",
                        "branch_name", "branch_location", // TODO: these are offering specific - should come from offer type
                        "item.itemtype.description",
                        "item.itemtype.keyword",
                        "item.itemtype.code"]
                }
            }
        };
        search("offerings", "offerings",
            qry,
            sr => {
                results.response = sr;
                results.string = JSON.stringify(sr);
                results.hits = sr.hits;
                res.redirect('/#search')
            }, er => {
                results.response = {};
                results.string = er;
                results.hits = 0;
                console.log(er);
                res.redirect('/#search')
            });
    });


    return app
}