fs = require('fs')

module.exports = (callback) ->
  express = @constructor.express

  @use '/public', express.static "#{@root}/public"
  @use '/public', (req, res, next) -> res.statusCode = 404; res.end()
  @use '/favicon.ico', (req, res, next) =>
    fs.readFile "#{@root}/public/favicon.ico", (err, data) ->
      if err then res.end() else res.end(data)

  @use express.urlencoded()
  @use express.json()
  @use express.methodOverride()
  @use express.cookieParser()

  @use require('./session-store').call @, express
  @use require('../lib/middleware/flash')()

  @use @router

  @use @set 'errorHandler' if @set 'errorHandler'

  require('./routes').call @

  callback()
