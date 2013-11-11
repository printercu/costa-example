module.exports = (express) ->
  store = new (require('connect-redis') express)
    db:     2
    prefix: ''

  process.on 'exit', -> store.client.quit()

  express.session
    store:  store
    secret: 'secret'
    key:    'sid'
    maxAge: 30 * 24 * 3600 * 1000 # 1 month
