var express = require('express');
var app = express();
var db = require('./db').pool;
var http = require('http')
var url = require('url')

var port = 80;
var validResponse = 200;
var invalidResponse = 422;

app.listen(port, () => console.log('Example app listening on port ' + port));

app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Credentials", "true");
    res.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.header("Access-Control-Allow-Headers", "Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers");
    next();
});

app.get('/filter', function (req, res) {
    var queryData = url.parse(req.url, true).query;

    if (queryData.min < 1) res.status(invalidResponse).send();
    if (queryData.max > 1000000) res.status(invalidResponse);

    var states = JSON.parse(queryData.states);
    console.log(states);
    var min = queryData.min;
    var max = queryData.max;

    var response = {'count': null};

    var query = `SELECT COUNT(*) Count FROM source_ScoreCard WHERE STABBR IN (${states}) AND UGDS BETWEEN ${min} AND ${max}`;

    console.log(query);

    db.getConnection(function(err, conn) {
        conn.query(query, function (err, rows, fields) {
            if (err) throw err;
            var count = rows[0].Count;
            console.log('The count is ', count);
            response.count = count;
        });
        conn.release();
    });
    res.status(validResponse).send(response)
});
