module.exports =
  handler: handler = (err) ->
    if typeof err is 'number'
      log err if err > 499
      err
    else
      status = err.status || err.statusCode || 500
      log err if status > 499
      status

  express: -> errorHandler = (err, req, res, next) ->
    res.statusCode = handler err
    res.end('')

  log: log = (err) ->
    date = new Date().toISOString()
    err = new Error(err?.toString() || 'unknown error') unless err?.stack?
    console.error date
    console.error err
    console.error err.stack
    console.error ''
