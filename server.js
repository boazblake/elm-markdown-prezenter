var jsonServer = require('json-server')

// server :: Express Server
var server = jsonServer.create()

// Set Default middlewares ( logger, static, cors and no-cache)
server.use(jsonServer.defaults())

var router = jsonServer.router('./dbs/solid/db.json')
server.use(router)

console.log('listening on 4000')
server.listen(4000)
