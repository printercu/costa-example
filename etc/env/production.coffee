module.exports = ->
  error_handler = require "#{@root}/lib/middleware/error_handler"
  @set 'errorHandler', error_handler.express()
  process.on 'uncaughtException', error_handler.handler

  @set 'port', 80
  @set 'host', 'printercu.2013.nodeknockout.com'
