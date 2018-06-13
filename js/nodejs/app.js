var express = require('express');
var app = express();
var db = require('./db').pool;
var http = require('http')
var url = require('url')

app.listen(3000, () => console.log('Example app listening on port 3000!'));

app.get('/', function (req, res) {
    db.getConnection(function(err, conn) {
        conn.query('SELECT INSTNM FROM source_ScoreCard LIMIT 1;', function (err, rows, fields) {
            if (err) throw err;
            console.log('The first record is ', rows[0].INSTNM);
            res.status(200).send('The first record is ' + rows[0].INSTNM)
        });
        conn.release();
    })
});

app.get('/search', function (req, res) {
    var queryData = url.parse(req.url, true).query;

    if (queryData.state) {
        res.status(200).send('State: ' + queryData.state)
    }
    else res.status(400).send()
});
