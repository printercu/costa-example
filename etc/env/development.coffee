module.exports = ->
  @set 'errorHandler', require('express-error').express3
    contextLinesCount:        7
    handleUncaughtException:  true

  @set 'host', 'localhost:3000'
