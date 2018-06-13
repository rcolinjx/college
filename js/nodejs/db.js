const mysql = require('mysql')
const config = require('./config.json')

var pool = mysql.createPool({
    connectionLimit: 10,
    host: config.host,
    user: config.user,
    password: config.password,
    database: config.database
})

// var connect = function(callback) {
//     pool.getConnection(function(err, connection) {
//         callback(err, connection);
//     });
// };

module.exports.pool = pool;